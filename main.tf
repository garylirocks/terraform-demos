terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.75.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "learning-rg"
    storage_account_name = "tfstatey2hkc"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
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