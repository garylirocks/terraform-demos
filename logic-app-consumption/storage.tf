resource "azurerm_storage_account" "example" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.temp.name
  location                 = local.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_storage_container" "demo" {
  name                  = "test-container"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "demo-txt" {
  name                   = "test-folder/demo.txt"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.demo.name
  type                   = "Block"
  source                 = "demo-files/demo.txt"
}
