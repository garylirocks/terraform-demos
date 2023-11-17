locals {
  location             = "Australia East"
  connection_name      = "azureblob-001"
  resource_group_name  = "rg-logicapp-001"
  storage_account_name = "stgarytemp001"
}

resource "azurerm_resource_group" "demo" {
  name     = local.resource_group_name
  location = local.location
}
