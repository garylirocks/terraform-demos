resource "azurerm_resource_group" "rg" {
  name     = "rg-networks-temp"
  location = "Australia East"
}

resource "azurerm_virtual_network" "vnets" {
  for_each            = local.vnets
  name                = "vnet-${each.key}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = each.value.vnet_address_space
}

module "azure-vnet-peering" {
  source  = "claranet/vnet-peering/azurerm"
  version = "5.0.1"

  for_each = local.peerings

  providers = {
    azurerm.src = azurerm
    azurerm.dst = azurerm
  }

  vnet_src_id  = resource.azurerm_virtual_network.vnets["spoke"].id
  vnet_dest_id = resource.azurerm_virtual_network.vnets[each.value.dest_vnet_key].id

  allow_forwarded_src_traffic  = false
  allow_forwarded_dest_traffic = false

  allow_virtual_src_network_access  = true
  allow_virtual_dest_network_access = true

  use_remote_src_gateway  = each.value.use_remote_src_gateway
  use_remote_dest_gateway = false

  allow_gateway_src_transit  = false
  allow_gateway_dest_transit = true
}
