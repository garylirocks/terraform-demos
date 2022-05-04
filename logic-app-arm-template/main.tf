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
  location             = "Australia East"
  connection_name      = "azureblob-001"
  resource_group_name  = "rg-temp-arm-001"
  storage_account_name = "stgarytemp001"
}

resource "azurerm_resource_group" "temp" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_resource_group_template_deployment" "example" {
  name                = "example-deploy"
  resource_group_name = azurerm_resource_group.temp.name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "logic_app_name" = {
      value = "logic-temp-arm-001"
    }
    "connections_azureblob_externalid" = {
      value = "/subscriptions/dcbcc87a-dc02-4d7c-b061-e6ad2e36a71b/resourceGroups/rg-temp-001/providers/Microsoft.Web/connections/azureblob-001"
    }
  })
  template_content = file("${path.module}/arm-templates/app-template.json")
}
