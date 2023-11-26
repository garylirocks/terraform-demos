resource "azurerm_resource_group" "log" {
  name     = "rg-log-aue-001"
  location = local.region
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "log-aue-001"
  location            = local.region
  resource_group_name = azurerm_resource_group.log.name
  daily_quota_gb      = 0.2
}
