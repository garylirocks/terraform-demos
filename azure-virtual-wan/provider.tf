terraform {
  required_providers {
    azurerm = {
      # Specify what version of the provider we are going to utilize
      source  = "hashicorp/azurerm"
      version = ">= 3.73.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}
