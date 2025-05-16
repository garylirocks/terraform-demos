resource "azurerm_service_plan" "example" {
  name                = "asp-${local.name}-001"
  resource_group_name = azurerm_resource_group.example.name
  location            = local.region
  os_type             = "Windows" // Seems extensions only work on Windows ?
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "example" {
  name                = "app-${local.name}-001"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}
}

// TODO: add code for site extensions
