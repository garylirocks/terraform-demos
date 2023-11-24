locals {
  name = "vpnsite"
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-${local.name}-001"
  location = var.region
}
