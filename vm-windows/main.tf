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

resource "random_string" "demo" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-demo-${random_string.demo.result}"
  location = "Australia East"
}
