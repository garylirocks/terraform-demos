resource "azurerm_resource_group" "demo" {
  location = local.location
  name     = "rg-networking-demo-001"
}
