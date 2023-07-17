resource "random_string" "demo" {
  length  = 6
  special = false
  upper   = false
}

locals {
  name = random_string.demo.result
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-linux-app-${local.name}"
  location = "australiaeast"
}

resource "azurerm_storage_account" "demo" {
  name                     = "stlinuxfunc${local.name}"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "demo" {
  name                = "asp-demo-${local.name}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "demo" {
  name                = "func-${local.name}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location

  storage_account_name       = azurerm_storage_account.demo.name
  storage_account_access_key = azurerm_storage_account.demo.primary_access_key
  service_plan_id            = azurerm_service_plan.demo.id

  site_config {}
}
