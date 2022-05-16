terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.22.0"
    }
  }
}

provider "azuread" {
  # Configuration options
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

# create an application
resource "azuread_application" "example" {
  display_name = "example"
}

output "application_name" {
  value = azuread_application.example.application_id
}
