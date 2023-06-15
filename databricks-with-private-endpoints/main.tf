resource "azurerm_resource_group" "all" {
  for_each = local.rgs
  location = local.location
  name     = "rg-${each.key}"
}
