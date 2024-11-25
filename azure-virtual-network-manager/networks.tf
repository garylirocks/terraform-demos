resource "azurerm_resource_group" "demo" {
  name     = "rg-vnet-manager-demo-001"
  location = local.location
}

resource "azurerm_virtual_network" "all" {
  for_each            = local.vnets
  name                = "vnet-${each.key}"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  address_space       = [each.value.vnet_address_space]
}

resource "azurerm_subnet" "vm" {
  for_each             = local.vnets
  name                 = "snet-vm"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.all[each.key].name
  address_prefixes     = [cidrsubnet(each.value.vnet_address_space, 8, 0)]
}
