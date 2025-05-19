# data "azurerm_log_analytics_workspace" "demo" {
#   name                = "log-test-001"
#   resource_group_name = "rg-common"
# }

resource "azurerm_container_app_environment" "demo" {
  name                = "cae-test-001"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  # logs_destination           = "log-analytics"
  # log_analytics_workspace_id = data.azurerm_log_analytics_workspace.demo.id
}

resource "azurerm_container_app_environment_storage" "logs" {
  name                         = "cae-test-001-storage-logs"
  container_app_environment_id = azurerm_container_app_environment.demo.id
  account_name                 = azurerm_storage_account.demo.name
  access_key                   = azurerm_storage_account.demo.primary_access_key
  share_name                   = azurerm_storage_share.container-logs.name
  access_mode                  = "ReadWrite"
}
