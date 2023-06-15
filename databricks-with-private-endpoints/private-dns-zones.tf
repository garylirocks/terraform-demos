##########
# for front-end ui and browser_auth
##########
resource "azurerm_private_dns_zone" "databricks-shared" {
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = azurerm_resource_group.all["prod"].name
}

resource "azurerm_private_dns_zone_virtual_network_link" "databricks-shared" {
  name                  = "link"
  resource_group_name   = azurerm_resource_group.all["prod"].name
  private_dns_zone_name = azurerm_private_dns_zone.databricks-shared.name
  virtual_network_id    = azurerm_virtual_network.all["prod"].id
  registration_enabled  = false
}



##########
# for back-end
##########
resource "azurerm_private_dns_zone" "databricks-prod-001" {
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = azurerm_resource_group.all["databricks"].name
}

resource "azurerm_private_dns_zone_virtual_network_link" "databricks-prod-001" {
  name                  = "link"
  resource_group_name   = azurerm_resource_group.all["databricks"].name
  private_dns_zone_name = azurerm_private_dns_zone.databricks-prod-001.name
  virtual_network_id    = azurerm_virtual_network.all["databricks"].id
  registration_enabled  = false
}
