resource "azurerm_resource_group" "all" {
  for_each = local.regions
  name     = "rg-vwan-lab-${each.key}"
  location = each.value.name
  tags = {
    environment = local.environment_tag
  }
}
