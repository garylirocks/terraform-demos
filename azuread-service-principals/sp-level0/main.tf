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

# create an application
resource "azuread_application" "level0" {
  display_name = "sp-level0"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "level0" {
  application_id = azuread_application.level0.application_id
  owners         = [data.azuread_client_config.current.object_id]
}

resource "azuread_directory_role" "role" {
  display_name = "Cloud application administrator"
}

resource "azuread_directory_role_member" "level0_role" {
  role_object_id   = azuread_directory_role.role.object_id
  member_object_id = azuread_service_principal.level0.object_id
}
