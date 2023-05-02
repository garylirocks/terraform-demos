resource "azurerm_log_analytics_workspace" "demo" {
  name                = "log-demo-001"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  daily_quota_gb      = 0.2
}
