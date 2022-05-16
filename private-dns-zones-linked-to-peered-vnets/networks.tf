resource "azurerm_resource_group" "rg" {
  for_each = local.instances
  name     = "rg-private-dns-${each.key}-001"
  location = "Australia East"
}

resource "azurerm_virtual_network" "vnets" {
  for_each            = local.instances
  name                = "vnet-${each.key}"
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  address_space       = each.value.vnet_address_space
}

resource "azurerm_subnet" "snets" {
  for_each             = local.instances
  name                 = "snet-${each.key}"
  resource_group_name  = azurerm_resource_group.rg[each.key].name
  virtual_network_name = azurerm_virtual_network.vnets[each.key].name
  address_prefixes     = each.value.snet_address_space
}

resource "azurerm_virtual_network_peering" "a-to-b" {
  name                         = "a-to-b"
  resource_group_name          = azurerm_resource_group.rg["a"].name
  virtual_network_name         = azurerm_virtual_network.vnets["a"].name
  remote_virtual_network_id    = azurerm_virtual_network.vnets["b"].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "b-to-a" {
  name                         = "b-to-a"
  resource_group_name          = azurerm_resource_group.rg["b"].name
  virtual_network_name         = azurerm_virtual_network.vnets["b"].name
  remote_virtual_network_id    = azurerm_virtual_network.vnets["a"].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_public_ip" "pips" {
  for_each            = local.instances
  name                = "pip-${each.key}"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location
  allocation_method   = "Static"
  sku                 = "Basic" # Basic public ips are open by default, so no need for NSG
}

resource "azurerm_network_interface" "nics" {
  for_each            = local.instances
  name                = "nic-${each.key}"
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name

  ip_configuration {
    name                          = "default"
    subnet_id                     = azurerm_subnet.snets[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pips[each.key].id
    primary                       = true
  }
}
