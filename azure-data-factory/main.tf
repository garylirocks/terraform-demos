terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-adf-demo-${var.env}-001"
  location = "Australia East"
}


resource "azurerm_data_factory" "example" {
  name                = "adf-${var.env}-demo-001"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  identity {
    type = "SystemAssigned"
  }

  dynamic "vsts_configuration" {
    for_each = var.vsts_configuration == null ? [] : [true]

    content {
      account_name    = var.vsts_configuration.account_name
      branch_name     = var.vsts_configuration.branch_name
      project_name    = var.vsts_configuration.project_name
      repository_name = var.vsts_configuration.repository_name
      root_folder     = var.vsts_configuration.root_folder
      tenant_id       = var.vsts_configuration.tenant_id
    }
  }
}

# assign a role to the ADF identity for access to storage account
resource "azurerm_role_assignment" "example" {
  scope                = azurerm_storage_account.example.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.example.identity[0].principal_id
}
