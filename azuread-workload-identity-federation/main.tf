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

data "azuread_client_config" "current" {}

# create an application
resource "azuread_application" "demo" {
  display_name = "sp-demo-workload-identity-federation"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "demo" {
  application_id = azuread_application.demo.application_id
  owners         = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_federated_identity_credential" "demo" {
  application_object_id = azuread_application.demo.object_id
  display_name          = "github-actions-workflow"
  description           = "Allow GitHub Actions workflow to authenticate to Azure"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"

  // specify the repo and environment
  subject = "repo:garylirocks/github-workflow-test:environment:prod"
}
