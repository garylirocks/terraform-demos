terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.22.0"
    }
  }
}

provider "azuread" {
  # Configuration options
}

resource "azuread_application" "authorized" {
  display_name = "example-authorized-app"
}

resource "azuread_application" "authorizer" {
  display_name = "example-authorizing-app"

  api {
    oauth2_permission_scope {
      admin_consent_description  = "Administer the application"
      admin_consent_display_name = "Administer"
      enabled                    = true
      id                         = "ced9c4c3-c273-4f0f-ac71-a20377b90f9c"
      type                       = "Admin"
      value                      = "administer"
    }

    oauth2_permission_scope {
      admin_consent_description  = "Access the application"
      admin_consent_display_name = "Access"
      enabled                    = true
      id                         = "2d5e07ca-664d-4d9b-ad61-ec07fd215213"
      type                       = "User"
      user_consent_description   = "Access the application"
      user_consent_display_name  = "Access"
      value                      = "user_impersonation"
    }
  }
}

resource "azuread_application_pre_authorized" "example" {
  application_object_id = azuread_application.authorizer.object_id
  authorized_app_id     = azuread_application.authorized.application_id
  permission_ids        = ["ced9c4c3-c273-4f0f-ac71-a20377b90f9c", "2d5e07ca-664d-4d9b-ad61-ec07fd215213"]
}
