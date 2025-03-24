resource "azurerm_virtual_network" "vnet-hub" {
  name                = "vnet-workload-001"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  address_space       = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "subnet-default" {
  name                 = "snet-default"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.1.1.0/26"]
}
