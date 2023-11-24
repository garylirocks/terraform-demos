resource "azurerm_log_analytics_workspace" "demo" {
  count               = var.create_monitoring ? 1 : 0
  name                = "log-demo-001"
  location            = azurerm_resource_group.all["aue"].location
  resource_group_name = azurerm_resource_group.all["aue"].name
  daily_quota_gb      = 0.2
}
