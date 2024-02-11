terraform {
  backend "local" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.91.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = "~> 1.12.0"
    }
  }
}

provider "azurerm" {
  features {}
}
