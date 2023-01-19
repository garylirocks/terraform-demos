# create a storage account, use it as a linked service in ADF
resource "azurerm_storage_account" "example" {
  name                     = "stadfdemo${var.env}001x"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_storage_container" "source" {
  name                  = "source"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "dest" {
  name                  = "dest"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}
