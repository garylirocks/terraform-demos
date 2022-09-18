resource "azurerm_private_dns_zone" "demo" {
  name                = "example.private"
  resource_group_name = azurerm_resource_group.demo.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "demo" {
  name                  = "link-${azurerm_virtual_network.demo.name}"
  resource_group_name   = azurerm_resource_group.demo.name
  private_dns_zone_name = azurerm_private_dns_zone.demo.name
  virtual_network_id    = azurerm_virtual_network.demo.id
  registration_enabled  = true
}
