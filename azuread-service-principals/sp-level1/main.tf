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

data "azuread_client_config" "current" {}

# read a user
data "azuread_user" "app_owner" {
  user_principal_name = var.app_owner
}

# create an application
resource "azuread_application" "level1" {
  display_name = "sp-level1"
  owners = [
    data.azuread_client_config.current.object_id,
    data.azuread_user.app_owner.object_id
  ]
}

resource "azuread_service_principal" "level1" {
  application_id = azuread_application.level1.application_id
  owners = [
    data.azuread_client_config.current.object_id,
    data.azuread_user.app_owner.object_id
  ]
}
