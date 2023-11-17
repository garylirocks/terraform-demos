resource "azurerm_service_plan" "demo" {
  name                = "asp-demo-001"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  os_type             = "Windows"
  sku_name            = "WS1"
}

resource "azurerm_logic_app_standard" "demo" {
  name                       = "logic-standard-demo-001"
  location                   = azurerm_resource_group.demo.location
  resource_group_name        = azurerm_resource_group.demo.name
  app_service_plan_id        = azurerm_service_plan.demo.id
  storage_account_name       = azurerm_storage_account.demo.name
  storage_account_access_key = azurerm_storage_account.demo.primary_access_key

  // =========== Section start ===========
  // A logic app created using default arguments doesn't work
  // Grabbed this secion from a manually created one which is working
  // So KEEP this section here
  https_only = true
  version    = "~4"
  site_config {
    dotnet_framework_version         = "v6.0" // need this for Azure Functions 4.x
    runtime_scale_monitoring_enabled = true
    use_32_bit_worker_process        = false
  }
  // =========== Section end ===========

  virtual_network_subnet_id = azurerm_subnet.logic-app-integration-001.id

  identity {
    type = "SystemAssigned"
  }
}
