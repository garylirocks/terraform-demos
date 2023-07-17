resource "random_string" "demo" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-app-conf-${random_string.demo.result}"
  location = "australiaeast"
}

resource "azurerm_app_configuration" "demo" {
  name                = "appcs-${random_string.demo.result}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
}
