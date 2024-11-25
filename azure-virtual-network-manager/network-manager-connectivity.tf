# add connectivity configuration
resource "azurerm_network_manager_connectivity_configuration" "hubspoke" {
  name                            = "connectivity-conf-hub-and-spoke"
  network_manager_id              = azurerm_network_manager.demo.id
  connectivity_topology           = "HubAndSpoke"
  delete_existing_peering_enabled = true

  hub {
    resource_id   = azurerm_virtual_network.all["hub"].id
    resource_type = "Microsoft.Network/virtualNetworks"
  }

  applies_to_group {
    group_connectivity = "None"
    network_group_id   = azurerm_network_manager_network_group.demo-001.id
  }
}

resource "azurerm_network_manager_deployment" "australiaeast-connectivity" {
  network_manager_id = azurerm_network_manager.demo.id
  location           = local.location
  scope_access       = "Connectivity"
  configuration_ids = [
    azurerm_network_manager_connectivity_configuration.hubspoke.id,
  ]
}
