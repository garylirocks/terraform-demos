data "azurerm_client_config" "current" {}

resource "azurerm_app_configuration_key" "demo" {
  configuration_store_id = azurerm_app_configuration.demo.id
  key                    = "TestApp:Settings:Message"
  value                  = "Data from Azure App Configuration"
  # label                  = "somelabel"
}
