resource "azurerm_network_security_group" "main" {
  location            = "australiaeast"
  name                = "nsg-vmss-01"
  resource_group_name = azurerm_resource_group.main.name
  security_rule       = []
  tags                = {}
}

resource "azurerm_virtual_network" "main" {
  address_space                  = ["172.17.0.0/16"]
  dns_servers                    = []
  location                       = "australiaeast"
  name                           = "vnet-vmss-01"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.main.name
  tags                           = {}
}

resource "azurerm_subnet" "main" {
  address_prefixes                              = ["172.17.0.0/24"]
  default_outbound_access_enabled               = true
  name                                          = "snet-vmss-01"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.main.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  virtual_network_name                          = azurerm_virtual_network.main.name
}
