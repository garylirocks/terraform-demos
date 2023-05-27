locals {
  keepers = {
    env = "dev-001"
  }
}

resource "random_string" "demo" {
  keepers = local.keepers
  length  = 6
  special = false
  upper   = false
}

resource "random_pet" "demo" {
  keepers = local.keepers
  length  = 2
}
