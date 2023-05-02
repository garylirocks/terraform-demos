resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_storage_account" "demo" {
  name                     = "stdemo${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "demo" {
  name                  = "demo"
  storage_account_name  = azurerm_storage_account.demo.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "demo" {
  name                   = "readme"
  storage_account_name   = azurerm_storage_account.demo.name
  storage_container_name = azurerm_storage_container.demo.name
  type                   = "Block"
  source                 = "README.md"
}
