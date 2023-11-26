resource "azurerm_storage_account" "demo" {
  name                     = "stdemo${random_string.demo.result}"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_monitor_diagnostic_setting" "storage" {
  name                       = "diagnostic-${azurerm_storage_account.demo.name}"
  target_resource_id         = azurerm_storage_account.demo.id
  log_analytics_workspace_id = local.workspace_id

  metric {
    category = "Capacity"
    enabled  = true
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "blob" {
  name                       = "diagnostic-${azurerm_storage_account.demo.name}-blob"
  target_resource_id         = "${azurerm_storage_account.demo.id}/blobServices/default"
  log_analytics_workspace_id = local.workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}
