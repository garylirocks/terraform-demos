locals {
  location = "Australia East"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "temp" {
  name     = "rg-temp-001"
  location = local.location
}

resource "azurerm_virtual_network" "temp" {
  name                = "vnet-temp-001"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.temp.location
  resource_group_name = azurerm_resource_group.temp.name
}

resource "azurerm_subnet" "endpoint" {
  name                 = "snet-endpoint-001"
  resource_group_name  = azurerm_resource_group.temp.name
  virtual_network_name = azurerm_virtual_network.temp.name
  address_prefixes     = ["10.0.1.0/24"]

  private_endpoint_network_policies_enabled = true
}
