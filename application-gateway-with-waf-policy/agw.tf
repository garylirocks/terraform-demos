resource "azurerm_application_gateway" "example" {
  name                = "agw-${local.name}-001"
  resource_group_name = azurerm_resource_group.example.name
  location            = local.region
  zones               = ["1", "2", "3"]
  enable_http2        = true
  fips_enabled        = false

  force_firewall_policy_association = true
  firewall_policy_id                = resource.azurerm_web_application_firewall_policy.example.id

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = 2
    max_capacity = 3
  }

  gateway_ip_configuration {
    name      = "gatewayipconfig"
    subnet_id = local.subnets["agw"].id
  }

  frontend_ip_configuration {
    name                 = "frontendipconfig-public"
    public_ip_address_id = azurerm_public_ip.example.id
  }

  frontend_ip_configuration {
    name                          = "frontendipconfig-private"
    subnet_id                     = local.subnets["agw"].id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.68"
  }

  frontend_port {
    name = "port1"
    port = "80"
  }

  http_listener {
    name                           = "listener-001"
    frontend_ip_configuration_name = "frontendipconfig-public"
    frontend_port_name             = "port1"
    host_names                     = []
    protocol                       = "Http"
    require_sni                    = false
  }

  backend_address_pool {
    name         = "pool-app-service"
    fqdns        = []
    ip_addresses = [azurerm_private_endpoint.example.private_service_connection[0].private_ip_address]
  }

  backend_http_settings {
    name                  = "backendsetting-001"
    cookie_based_affinity = "Disabled"
    affinity_cookie_name  = null
    path                  = "/"
    port                  = "443"
    probe_name            = "probe-001"
    protocol              = "Https"
    request_timeout       = "30"
    host_name             = azurerm_linux_web_app.example.default_hostname
    connection_draining {
      enabled           = "false"
      drain_timeout_sec = "30"
    }
  }

  request_routing_rule {
    name                       = "rule-001"
    rule_type                  = "Basic"
    http_listener_name         = "listener-001"
    backend_address_pool_name  = "pool-app-service"
    backend_http_settings_name = "backendsetting-001"
    priority                   = 10
  }

  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  probe {
    name                                      = "probe-001"
    interval                                  = 30
    protocol                                  = "Https"
    path                                      = "/"
    timeout                                   = 30
    unhealthy_threshold                       = 3
    port                                      = 443
    pick_host_name_from_backend_http_settings = true
    match {
      status_code = ["200-399"]
      body        = ""
    }
    minimum_servers = 0
  }
}

output "url" {
  description = "URL to the application gateway"
  value       = "http://${azurerm_public_ip.example.ip_address}"
}
