resource "azurerm_private_dns_zone" "example" {
  name                = "azure.example.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  name                  = "link-to-hub"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = azurerm_virtual_network.vnets["hub"].id
  registration_enabled  = true
}

resource "azurerm_private_dns_a_record" "records" {
  name                = "test"
  zone_name           = azurerm_private_dns_zone.example.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [local.instances.hub.a_record_ip]
}
