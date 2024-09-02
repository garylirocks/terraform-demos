resource "azurerm_service_plan" "example" {
  name                = "asp-${local.name}-001"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "example" {
  name                          = "app-${local.name}-001"
  resource_group_name           = azurerm_resource_group.example.name
  location                      = azurerm_service_plan.example.location
  service_plan_id               = azurerm_service_plan.example.id
  public_network_access_enabled = false

  site_config {}
}

module "private-endpoint" {
  pe_resource_name       = "pep-${azurerm_linux_web_app.example.name}"
  pe_resource_group_name = azurerm_resource_group.example.name
  subnet_id              = module.workload-subnet.id["snet-workload"]
  endpoint_resource_id   = azurerm_linux_web_app.example.id

  subresource_names = ["sites"]

  // you can customize the NIC resource name
  # custom_network_interface_name = "nic-${data.azurerm_storage_account.myStorage.name}"
}
