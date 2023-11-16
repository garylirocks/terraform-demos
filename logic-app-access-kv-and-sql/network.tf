resource "azurerm_virtual_network" "demo" {
  name                = "vnet-demo-001"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
}

resource "azurerm_subnet" "private-endpoints" {
  name                 = "snet-endpoint-001"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "logic-app-integration-001" {
  name                 = "snet-logic-app-integration-001"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}


// the private DNS zone to add DNS record to
resource "azurerm_private_dns_zone" "kv" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.demo.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv" {
  name                  = azurerm_private_dns_zone.kv.name
  resource_group_name   = azurerm_resource_group.demo.name
  private_dns_zone_name = azurerm_private_dns_zone.kv.name
  virtual_network_id    = azurerm_virtual_network.demo.id
  registration_enabled  = false
}
