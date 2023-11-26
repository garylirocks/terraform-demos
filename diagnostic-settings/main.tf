locals {
  region       = "Australia East"
  workspace_id = "/subscriptions/dcbcc87a-dc02-4d7c-b061-e6ad2e36a71b/resourceGroups/rg-log-aue-001/providers/Microsoft.OperationalInsights/workspaces/log-aue-001"
}

resource "random_string" "demo" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "demo" {
  // TODO change resource group name, it could containe other resource types
  name     = "rg-storage-${random_string.demo.result}"
  location = local.region
}
