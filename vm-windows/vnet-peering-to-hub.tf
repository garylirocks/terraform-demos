module "azure_vnet_peering" {
  source  = "claranet/vnet-peering/azurerm"
  version = "8.0.0"

  count = var.hub_vnet_id != "" ? 1 : 0

  providers = {
    azurerm.src  = azurerm
    azurerm.dest = azurerm
  }

  src_virtual_network_id  = azurerm_virtual_network.vnet-hub.id
  dest_virtual_network_id = var.hub_vnet_id

  src_forwarded_traffic_allowed  = false
  dest_forwarded_traffic_allowed = true

  src_virtual_network_access_allowed  = true
  dest_virtual_network_access_allowed = true
}
