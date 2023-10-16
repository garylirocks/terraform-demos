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

data "azuread_client_config" "current" {}

# reference the state file in base-resources folder
data "terraform_remote_state" "base" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
}

data "azurerm_key_vault_secret" "secrets" {
  for_each     = data.terraform_remote_state.base.outputs.keyvault_ids
  name         = "top-secret"
  key_vault_id = each.value
}

output "secret_value" {
  value     = data.azurerm_key_vault_secret.secrets
  sensitive = true
}
