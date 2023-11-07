resource "azurerm_public_ip" "example" {
  name                = "pip-${local.name}-001"
  resource_group_name = azurerm_resource_group.example.name
  location            = local.region
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}
