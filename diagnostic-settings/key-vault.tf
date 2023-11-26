data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "demo" {
  name                = "kv-demo-${random_string.demo.result}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  sku_name            = "standard"

  tenant_id = data.azurerm_client_config.current.tenant_id

  enabled_for_disk_encryption = true
  purge_protection_enabled    = false
}

resource "azurerm_monitor_diagnostic_setting" "kv" {
  name                       = "diagnostic-${azurerm_key_vault.demo.name}"
  target_resource_id         = azurerm_key_vault.demo.id
  log_analytics_workspace_id = local.workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
