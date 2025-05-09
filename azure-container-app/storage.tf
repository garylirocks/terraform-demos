resource "random_string" "demo" {
  length  = 6
  special = false
  upper   = false
}

locals {
  name = random_string.demo.result
}

resource "azurerm_storage_account" "demo" {
  name                     = "stcaetest${local.name}"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "container-logs" {
  name               = "container-logs"
  storage_account_id = azurerm_storage_account.demo.id
  quota              = 10
}
