terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.72.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_subscription_template_deployment" "example" {
  name               = "deployment-demo-from-terraform-001"
  location           = "Australia East"
  template_content   = file("arm-template.json")
  parameters_content = file("arm-parameters.json")
}
