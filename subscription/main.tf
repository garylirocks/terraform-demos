terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

variable "sub_id" {
  type = string
}

variable "billing_account_name" {
  type = string
}

variable "billing_profile_name" {
  type = string
}

variable "invoice_section_name" {
  type = string
}

// manage alias of an existing subscription
resource "azurerm_subscription" "test" {
  alias             = "test-alias-2"
  subscription_name = "sub-test"
  subscription_id   = var.sub_id
  tags = {
    "tag1" = "foo"
  }
}

data "azurerm_billing_mca_account_scope" "example" {
  billing_account_name = var.billing_account_name
  billing_profile_name = var.billing_profile_name
  invoice_section_name = var.invoice_section_name
}

resource "random_id" "id" {
  byte_length = 5
}

// Create a new subscription
//  and an alias, if "alias" argument not supplied, it will be generated automatically
resource "azurerm_subscription" "new" {
  subscription_name = "sub-MCA-demo-${random_id.id.hex}"
  alias             = "alias-${random_id.id.hex}"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.example.id
}
