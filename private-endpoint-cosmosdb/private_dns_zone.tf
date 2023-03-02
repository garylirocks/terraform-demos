resource "azurerm_private_dns_zone" "temp" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = azurerm_resource_group.temp.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "temp" {
  name                  = "vnetlink-temp"
  resource_group_name   = azurerm_resource_group.temp.name
  private_dns_zone_name = azurerm_private_dns_zone.temp.name
  virtual_network_id    = azurerm_virtual_network.temp.id
}
