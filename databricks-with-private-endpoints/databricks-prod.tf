# production workspace
resource "azurerm_databricks_workspace" "production" {
  name                = "dbw-production-001"
  resource_group_name = azurerm_resource_group.all["databricks"].name
  location            = local.location
  sku                 = "premium"

  managed_resource_group_name   = "rg-managed-dbw-production-001"
  public_network_access_enabled = false
  # load_balancer_backend_address_pool_id = azurerm_lb_backend_address_pool.databricks.id // Databricks will manage configs of the load balancer
  network_security_group_rules_required = "NoAzureDatabricksRules"

  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = azurerm_virtual_network.all["databricks"].id
    public_subnet_name                                   = "snet-databricks-public"
    private_subnet_name                                  = "snet-databricks-private"
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.abw-subnets["databricks-public"].id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.abw-subnets["databricks-private"].id
  }
}

resource "azurerm_private_endpoint" "prod-001-ui-api-frontend" {
  name                = "pep-prod-001-ui-api-frontend"
  location            = local.location
  resource_group_name = azurerm_resource_group.all["databricks"].name
  subnet_id           = azurerm_subnet.all["prod-frontend-pep"].id

  private_service_connection {
    name                           = "frontend"
    private_connection_resource_id = azurerm_databricks_workspace.production.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.databricks-shared.id]
  }
}

resource "azurerm_private_endpoint" "prod-001-ui-api-backend" {
  # can't create two PEPs at the same time, queue backend after the frontend one
  depends_on = [
    azurerm_private_endpoint.prod-001-ui-api-frontend
  ]
  name                = "pep-prod-001-ui-api-backend"
  location            = local.location
  resource_group_name = azurerm_resource_group.all["databricks"].name
  subnet_id           = azurerm_subnet.all["databricks-backend-pep"].id

  private_service_connection {
    name                           = "backend"
    private_connection_resource_id = azurerm_databricks_workspace.production.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.databricks-prod-001.id]
  }
}


##########
# Egress load balancer
##########
# resource "azurerm_public_ip" "egress-lb" {
#   name                    = "pip-egress-lb"
#   location                = azurerm_resource_group.all["databricks"].location
#   resource_group_name     = azurerm_resource_group.all["databricks"].name
#   idle_timeout_in_minutes = 4
#   allocation_method       = "Static"

#   sku = "Standard"
# }


# resource "azurerm_lb" "egress-lb" {
#   name                = "lbe-egress"
#   location            = azurerm_resource_group.all["databricks"].location
#   resource_group_name = azurerm_resource_group.all["databricks"].name

#   sku = "Standard"

#   frontend_ip_configuration {
#     name                 = "pip-egress-lb"
#     public_ip_address_id = azurerm_public_ip.egress-lb.id
#   }
# }

# resource "azurerm_lb_outbound_rule" "egress" {
#   name = "rule-databricks-egress"

#   loadbalancer_id          = azurerm_lb.egress-lb.id
#   protocol                 = "All"
#   enable_tcp_reset         = true
#   allocated_outbound_ports = 1024
#   idle_timeout_in_minutes  = 4

#   backend_address_pool_id = azurerm_lb_backend_address_pool.databricks.id

#   frontend_ip_configuration {
#     name = azurerm_lb.egress-lb.frontend_ip_configuration.0.name
#   }
# }

# resource "azurerm_lb_backend_address_pool" "databricks" {
#   loadbalancer_id = azurerm_lb.egress-lb.id
#   name            = "databricks-backend-pool"
# }
