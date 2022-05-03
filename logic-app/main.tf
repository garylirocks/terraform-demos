terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 2.75.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  location        = "Australia East"
  connection_name = "azureblob-001"
}

resource "azurerm_resource_group" "temp" {
  name     = "rg-temp-001"
  location = local.location
}

data "azurerm_managed_api" "example" {
  name     = "azureblob"
  location = local.location
}

# an API connection to a storage account
resource "azurerm_api_connection" "example" {
  name                = local.connection_name
  resource_group_name = azurerm_resource_group.temp.name
  managed_api_id      = data.azurerm_managed_api.example.id
  display_name        = "Blob Connection 001"

  parameter_values = {
    accountName = "stgarytemp001"
    accessKey   = var.access_key
  }

  lifecycle {
    # NOTE: since the connectionString is a secure value it's not returned from the API
    ignore_changes = [parameter_values]
  }
}

resource "azurerm_logic_app_workflow" "example" {
  name                = "logic-temp-001"
  location            = azurerm_resource_group.temp.location
  resource_group_name = azurerm_resource_group.temp.name

  workflow_parameters = {
    "$connections" = jsonencode(
      {
        defaultValue = {}
        type         = "Object"
      }
    )
  }

  parameters = {
    "$connections" = jsonencode(
      {
        azureblob = {
          connectionId   = azurerm_api_connection.example.id
          connectionName = local.connection_name
          id             = data.azurerm_managed_api.example.id
        }
      }
    )
  }
}
