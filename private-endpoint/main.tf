terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

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
  address_prefixes     = ["10.0.2.0/24"]

  enforce_private_link_endpoint_network_policies = true
}

// the resource what the endpoint points to
resource "azurerm_key_vault" "temp" {
  name                        = "kv-temp-gary-001"
  location                    = local.location
  resource_group_name         = azurerm_resource_group.temp.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false
  sku_name                    = "standard"
}

// the private DNS zone to add DNS record to
resource "azurerm_private_dns_zone" "temp" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.temp.name
}

resource "azurerm_private_endpoint" "temp" {
  name                = "pe-temp-001"
  location            = azurerm_resource_group.temp.location
  resource_group_name = azurerm_resource_group.temp.name
  subnet_id           = azurerm_subnet.endpoint.id

  private_service_connection {
    name                           = "temp-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.temp.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  // create privatae dns zone group
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.temp.id]
  }
}
