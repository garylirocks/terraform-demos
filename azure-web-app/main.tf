resource "random_pet" "name" {
}

resource "azurerm_resource_group" "example" {
  name     = "rg-app-${local.name}-001"
  location = local.region
}
