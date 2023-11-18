terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  location = "Australia East"
}

// this only outputs user id, not user name
data "azurerm_client_config" "current" {}

// need to get user principal name this way
data "azuread_user" "current_user" {
  object_id = data.azurerm_client_config.current.object_id
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

  azuread_administrator {
    azuread_authentication_only = false
    login_username              = data.azuread_user.current_user.user_principal_name
    object_id                   = data.azurerm_client_config.current.object_id
  }
}

resource "azurerm_mssql_database" "test" {
  name                 = "sqldb-test-001"
  server_id            = azurerm_mssql_server.sql.id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  sku_name             = "Basic"
  zone_redundant       = false
  read_scale           = false
  storage_account_type = "Local"
  sample_name          = "AdventureWorksLT" // load sample data
}
