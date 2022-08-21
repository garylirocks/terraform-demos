terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 3.0.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "> 0.1.0"
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

provider "azurerm" {
  alias           = "dns"
  subscription_id = "70256be7-d155-4702-8976-0e7f9a046876"
  features {}
}
