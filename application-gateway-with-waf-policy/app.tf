resource "azurerm_service_plan" "example" {
  name                = "asp-${local.name}-001"
  resource_group_name = azurerm_resource_group.example.name
  location            = local.region
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "example" {
  name                = "app-${local.name}-001"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}
}

resource "azurerm_private_endpoint" "example" {
  name                          = "pep-${azurerm_linux_web_app.example.name}"
  location                      = local.region
  resource_group_name           = azurerm_resource_group.example.name
  subnet_id                     = local.subnets["workload"].id
  custom_network_interface_name = "nic-${azurerm_linux_web_app.example.name}"

  private_service_connection {
    name                           = "privateserviceconnection"
    private_connection_resource_id = azurerm_linux_web_app.example.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}
