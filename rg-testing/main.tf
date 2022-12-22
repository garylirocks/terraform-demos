resource "azurerm_resource_group" "demo" {
  location = local.location
  name     = "rg-${local.name}"
}
