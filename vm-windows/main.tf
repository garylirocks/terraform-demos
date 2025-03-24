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

  subscription_id = var.subscription_id
}

resource "random_string" "demo" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-demo-${random_string.demo.result}"
  location = "Australia East"
}
