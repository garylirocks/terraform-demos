terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.75.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# create a resource group
resource "azurerm_resource_group" "example" {
  name     = "gary-terraform-example"
  location = "Australia East"
}