resource "azurerm_monitor_data_collection_rule" "demo" {
  name                = "dcr-${local.name}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location

  description = "data collection rule demo"

  data_sources {
    syslog {
      facility_names = ["*"]
      log_levels     = ["*"]
      name           = "demo-datasource-syslog"
      streams        = ["Microsoft-Syslog"]
    }
  }

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.demo.id
      name                  = "demo-destination-log"
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["demo-destination-log"]
  }

  tags = {
    foo = "bar"
  }

  depends_on = [
    azurerm_log_analytics_workspace.demo
  ]
}

# associate DCR to a VM
resource "azurerm_monitor_data_collection_rule_association" "demo" {
  name                    = "dcra-${local.name}"
  data_collection_rule_id = azurerm_monitor_data_collection_rule.demo.id
  target_resource_id      = azurerm_linux_virtual_machine.demo.id
}
