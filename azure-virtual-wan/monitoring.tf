resource "azurerm_log_analytics_workspace" "demo" {
  count               = var.create_monitoring ? 1 : 0
  name                = "log-demo-001"
  location            = azurerm_resource_group.all["aue"].location
  resource_group_name = azurerm_resource_group.all["aue"].name
  daily_quota_gb      = 0.2
}

# TODO vHubs do not support diagnostic settings
# resource "azurerm_monitor_diagnostic_setting" "vhubs" {
#   for_each                   = var.create_monitoring ? local.regions : {}
#   name                       = "diagnostic-${azurerm_virtual_hub.all[each.key].name}"
#   target_resource_id         = azurerm_virtual_hub.all[each.key].id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.demo[0].id

#   metric {
#     category = "AllMetrics"
#   }
# }
