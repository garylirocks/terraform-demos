# For Prometheus metrics
resource "azurerm_monitor_workspace" "demo" {
  name                = "amw-demo-001"
  resource_group_name = azurerm_resource_group.demo.name
  location            = local.location
}


resource "azurerm_dashboard_grafana" "demo" {
  name                              = "grafana-demo-001"
  resource_group_name               = azurerm_resource_group.demo.name
  location                          = local.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = false

  identity {
    type = "SystemAssigned"
  }
}
