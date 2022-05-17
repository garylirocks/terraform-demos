resource "azurerm_resource_group" "rg" {
  name     = "rg-networks-temp-002"
  location = "Australia East"
}

# other vnets
resource "azurerm_virtual_network" "other" {
  for_each            = toset(local.other_vnet_keys)
  name                = "vnet-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = local.vnets[each.value].address_space
}

# NOTE: make sure the vnet with the "last" flag is created last
resource "azurerm_virtual_network" "last" {
  for_each = { (local.last_vnet_key) = local.last_vnet_key }
  depends_on = [
    azurerm_virtual_network.other
  ]
  name                = "vnet-${local.last_vnet_key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = local.vnets[local.last_vnet_key].address_space
}

# "last" flag moved from vnet a to b
moved {
  from = azurerm_virtual_network.last["a"]
  to   = azurerm_virtual_network.other["a"]
}

moved {
  from = azurerm_virtual_network.other["b"]
  to   = azurerm_virtual_network.last["b"]
}
