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

variable "sub_id" {
  type = string
}

// this manages alias resources associated with a subscription
resource "azurerm_subscription" "test" {
  alias             = "test-alias"
  subscription_name = "sub-test"
  subscription_id   = var.sub_id
  tags = {
    "tag1" = "foo"
  }
}
