resource "random_id" "storage_account" {
  byte_length = 5
}

resource "azurerm_storage_account" "demo" {
  name                     = "st${random_id.storage_account.hex}"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "demo" {
  name                = "asp-demo-001"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  os_type             = "Windows"
  sku_name            = "WS1"
}

resource "azurerm_logic_app_standard" "demo" {
  name                       = "logic-demo-standard-001"
  location                   = azurerm_resource_group.demo.location
  resource_group_name        = azurerm_resource_group.demo.name
  app_service_plan_id        = azurerm_service_plan.demo.id
  storage_account_name       = azurerm_storage_account.demo.name
  storage_account_access_key = azurerm_storage_account.demo.primary_access_key

  identity {
    type = "SystemAssigned"
  }
}
