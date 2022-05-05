terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 2.75.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "user_principal_name" {
  type = string
}

# read a user
data "azuread_user" "example" {
  user_principal_name = var.user_principal_name
}

output "given_name" {
  value = data.azuread_user.example.given_name
}
