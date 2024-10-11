terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  # need to add subscription id with
  # export ARM_SUBSCRIPTION_ID=00000000-xxxx-xxxx-xxxx-xxxxxxxxxxxx
}

locals {
  location = "Australia East"
}


resource "azurerm_resource_group" "example" {
  name     = "rg-purview-test"
  location = local.location
}

resource "azurerm_purview_account" "example" {
  name                = "pview-test-001"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  identity {
    type = "SystemAssigned"
  }
}
