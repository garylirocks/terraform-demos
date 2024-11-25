# NOTE: Does not support the aggregated CIDR as source/destination option
resource "azurerm_network_manager_security_admin_configuration" "demo" {
  name                                          = "securityadmin-conf-001"
  network_manager_id                            = azurerm_network_manager.demo.id
  apply_on_network_intent_policy_based_services = ["None"]
}

resource "azurerm_network_manager_admin_rule_collection" "demo" {
  name                            = "Allow-SSH-to-spoke"
  security_admin_configuration_id = azurerm_network_manager_security_admin_configuration.demo.id
  network_group_ids = [
    azurerm_network_manager_network_group.demo-001.id
  ]
}

resource "azurerm_network_manager_admin_rule" "allow-ssh-to-spoke" {
  name                     = "Allow-SSH-from-hub"
  description              = "Allow SSH access from hub VM to spoke VMs"
  admin_rule_collection_id = azurerm_network_manager_admin_rule_collection.demo.id
  action                   = "AlwaysAllow"
  direction                = "Inbound"
  priority                 = 100
  protocol                 = "Tcp"
  source_port_ranges       = ["0-65535"]
  destination_port_ranges  = ["22"]

  source {
    address_prefix_type = "IPPrefix"
    address_prefix      = "10.0.0.0/24" # hub subnet
  }

  source {
    address_prefix_type = "IPPrefix"
    address_prefix      = "10.1.0.0/24" # admin subnet (management)
  }

  destination {
    address_prefix_type = "IPPrefix" # NOTE: does not support NetworkGroup yet
    address_prefix      = "10.16.0.0/12"
  }
}

resource "azurerm_network_manager_deployment" "australiaeast-securityadmin" {
  network_manager_id = azurerm_network_manager.demo.id
  location           = local.location
  scope_access       = "SecurityAdmin"
  configuration_ids = [
    azurerm_network_manager_security_admin_configuration.demo.id
  ]
}
