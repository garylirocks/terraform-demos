terraform {
  backend "local" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.19.1"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true

  features {}
}
