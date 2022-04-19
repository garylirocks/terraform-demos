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
  location = "Australia East"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-temp-001"
  location = local.location
}

resource "azurerm_mssql_server" "sql" {
  name                         = "sql-temp-001"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.administrator_login_password
}
