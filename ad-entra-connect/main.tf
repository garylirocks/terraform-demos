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

#######################################################################
## Resource Groups
#######################################################################

resource "azurerm_resource_group" "all" {
  for_each = local.resource_groups
  name     = "rg-${each.key}"
  location = local.location
}
