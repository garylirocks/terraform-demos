resource "azurerm_private_dns_zone" "zones" {
  for_each            = local.instances
  name                = "private.example.com"
  resource_group_name = azurerm_resource_group.rg[each.key].name
}

resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  for_each              = local.instances
  name                  = "link-${each.key}"
  resource_group_name   = azurerm_resource_group.rg[each.key].name
  private_dns_zone_name = azurerm_private_dns_zone.zones[each.key].name
  virtual_network_id    = azurerm_virtual_network.vnets[each.key].id
  registration_enabled  = true
}

resource "azurerm_private_dns_a_record" "records" {
  for_each            = local.instances
  name                = "test"
  zone_name           = azurerm_private_dns_zone.zones[each.key].name
  resource_group_name = azurerm_resource_group.rg[each.key].name
  ttl                 = 300
  records             = [each.value.a_record_ip]
}
