module "pip-agw" {
  resource_names      = "pip-${local.name}-001"
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}
