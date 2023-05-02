resource "azurerm_virtual_network" "vnet-hub" {
  name                = "vnet-test"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet-default" {
  name                 = "subnet-default"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.0.0/24"]
}
