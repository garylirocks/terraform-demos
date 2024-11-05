resource "azurerm_resource_group" "rg" {
  name     = "rg-dns-private-resolver-test-001"
  location = "Australia East"
}

resource "azurerm_virtual_network" "vnets" {
  for_each            = local.instances
  name                = "vnet-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = each.value.vnet_address_space
  dns_servers         = each.value.dns_server_ips
}

resource "azurerm_subnet" "snets" {
  for_each             = local.instances
  name                 = "snet-${each.key}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnets[each.key].name
  address_prefixes     = each.value.snet_vm_address_space
}

resource "azurerm_public_ip" "pips" {
  for_each            = local.instances
  name                = "pip-${each.key}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Basic" # Basic public ips are open by default, so no need for NSG
}

resource "azurerm_network_interface" "nics" {
  for_each            = local.instances
  name                = "nic-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "default"
    subnet_id                     = azurerm_subnet.snets[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pips[each.key].id
    primary                       = true
  }
}

resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  name                         = "hub-to-spoke"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnets["hub"].name
  remote_virtual_network_id    = azurerm_virtual_network.vnets["spoke"].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name                         = "spoke-to-hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnets["spoke"].name
  remote_virtual_network_id    = azurerm_virtual_network.vnets["hub"].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "hub-to-on-prem" {
  name                         = "hub-to-on-prem"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnets["hub"].name
  remote_virtual_network_id    = azurerm_virtual_network.vnets["on-prem"].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "on-prem-to-hub" {
  name                         = "on-prem-to-hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnets["on-prem"].name
  remote_virtual_network_id    = azurerm_virtual_network.vnets["hub"].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
