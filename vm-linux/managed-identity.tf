resource "azurerm_user_assigned_identity" "demo" {
  name                = "mi-${local.name}"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
}
