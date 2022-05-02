resource "azurerm_resource_group" "dns" {
  provider = azurerm.dns
  name     = "rg-dns-001"
  location = local.location
}


// the private DNS zone to add DNS record to
resource "azurerm_private_dns_zone" "temp" {
  provider            = azurerm.dns
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.dns.name
}
