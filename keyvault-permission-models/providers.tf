terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 3.0.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.43.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = false
      recover_soft_deleted_secrets          = true
    }
  }
}
