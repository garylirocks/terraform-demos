terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.10.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-common"
    storage_account_name = "stterraformstatex001"
    container_name       = "tfstate"
    key                  = "pim_role_assignment.tfstate"
  }

  # cloud {
  #   organization = "garylirocks"

  #   workspaces {
  #     name = "pim-role-assignments"
  #   }
  # }
}

provider "azurerm" {
  features {}
}
