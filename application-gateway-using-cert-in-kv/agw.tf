module "app_gateway" {
  appgw_name                 = "agw-${local.name}-001"
  resource_group_name        = azurerm_resource_group.example.name
  zones                      = ["1", "2", "3"]
  enable_http2               = true
  use_for_agic               = false
  log_analytics_workspace_id = null

  force_firewall_policy_association = true
  firewall_policy_id                = resource.azurerm_web_application_firewall_policy.example.id

  sku = {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration = {
    min_capacity = 2
    max_capacity = 3
  }

  identity_ids = [azurerm_user_assigned_identity.example.id]

  gateway_ip_configuration = [{
    name      = "gatewayipconfig"
    subnet_id = module.workload-subnet.id["snet-agw"]
  }]

  frontend_ip_configuration = [
    {
      name                 = "frontendipconfig-public"
      public_ip_address_id = module.pip-agw.id
    },
    {
      name                          = "frontendipconfig-private"
      subnet_id                     = module.workload-subnet.id["snet-agw"]
      private_ip_address_allocation = "Static"
      private_ip_address            = "10.0.0.68"
    }
  ]

  frontend_port = [
    {
      name = "port1"
      port = "80"
    },
    {
      name = "port-https"
      port = "443"
    }
  ]

  http_listener = [
    {
      name                           = "listener-public-001"
      frontend_ip_configuration_name = "frontendipconfig-public"
      frontend_port_name             = "port1"
      host_names                     = []
      protocol                       = "Http"
      require_sni                    = false
      firewall_policy_id             = resource.azurerm_web_application_firewall_policy.site.id
    },
    {
      name                           = "listener-public-https-001"
      frontend_ip_configuration_name = "frontendipconfig-public"
      frontend_port_name             = "port-https"
      host_names                     = ["garytest.com"]
      protocol                       = "Https"
      require_sni                    = false
      firewall_policy_id             = resource.azurerm_web_application_firewall_policy.site.id
      ssl_certificate_name           = "testcert1"
    },
    {
      name                           = "listener-private-001"
      frontend_ip_configuration_name = "frontendipconfig-private"
      frontend_port_name             = "port1"
      host_names                     = []
      protocol                       = "Http"
      require_sni                    = false
      firewall_policy_id             = resource.azurerm_web_application_firewall_policy.site.id
    }
  ]

  ssl_certificate = [
    {
      name                = "testcert1"
      key_vault_secret_id = "https://kv-test-enhanced-spaniel.vault.azure.net/secrets/garytest/58222fab89a74e12ad57a8f9ad324efa"
    }
  ]

  backend_address_pool = [
    {
      name         = "pool-app-service"
      fqdns        = []
      ip_addresses = [module.private-endpoint.private_service_connection[0].private_ip_address]
    }
  ]

  backend_http_settings = [{
    name                                = "backendsetting-001"
    cookie_based_affinity               = "Disabled"
    affinity_cookie_name                = null
    path                                = "/"
    port                                = "443"
    probe_name                          = "probe-001"
    protocol                            = "Https"
    request_timeout                     = "30"
    host_name                           = azurerm_linux_web_app.example.default_hostname
    pick_host_name_from_backend_address = false
    connection_draining = {
      enabled           = "false"
      drain_timeout_sec = "30"
    }
  }]

  fips_enabled = false

  # identity_ids = ["/subscriptions/60931080-92fe-4118-9332-8d3f4d947487/resourceGroups/AZU-SYD-PDP-Test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/UA-ManagedIdentity"]

  # private_link_configuration = [{
  #   name = "privatelink1"
  #   ip_configuration = [{
  #     name                          = "privateLinkIpConfig2"
  #     subnet_id                     = "/subscriptions/60931080-92fe-4118-9332-8d3f4d947487/resourceGroups/AZU-SYD-PDP-Test/providers/Microsoft.Network/virtualNetworks/AZU-VNET-INTEGRATION-SBX/subnets/AZU-SUB-INTEGRATION-SBX-002"
  #     private_ip_address_allocation = "Dynamic"
  #     primary                       = true
  #   }]
  # }]

  request_routing_rule = [
    {
      name                       = "rule-private-001"
      rule_type                  = "Basic"
      http_listener_name         = "listener-private-001"
      backend_address_pool_name  = "pool-app-service"
      backend_http_settings_name = "backendsetting-001"
      priority                   = 20
    },
    {
      name                       = "rule-public-001"
      rule_type                  = "PathBasedRouting"
      http_listener_name         = "listener-public-001"
      backend_address_pool_name  = "pool-app-service"
      backend_http_settings_name = "backendsetting-001"
      priority                   = 10
      url_path_map_name          = "rule-public-001"
    },
    {
      name                       = "rule-public-002"
      rule_type                  = "Basic"
      http_listener_name         = "listener-public-https-001"
      backend_address_pool_name  = "pool-app-service"
      backend_http_settings_name = "backendsetting-001"
      priority                   = 15
    }
  ]

  ssl_policy = {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }

  ssl_profile = []

  probe = [{
    name                                      = "probe-001"
    host                                      = "127.0.0.1"
    interval                                  = 30
    protocol                                  = "Https"
    path                                      = "/"
    timeout                                   = 30
    unhealthy_threshold                       = 3
    port                                      = 443
    pick_host_name_from_backend_http_settings = true
    match = {
      status_code = ["200-399"]
      body        = ""
    }
    minimum_servers = 0
  }]

  url_path_map = [
    {
      name                               = "rule-public-001"
      default_backend_address_pool_name  = "pool-app-service"
      default_backend_http_settings_name = "backendsetting-001"

      path_rule = [
        {
          name                       = "log_files"
          backend_address_pool_name  = "pool-app-service"
          backend_http_settings_name = "backendsetting-001"
          paths = [
            "/log*",
          ]
          firewall_policy_id = resource.azurerm_web_application_firewall_policy.uri.id
        }
      ]
    }
  ]

  rewrite_rule_set       = []
  redirect_configuration = []
}
