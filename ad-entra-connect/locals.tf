locals {
  location = "Australia East"
  password = file("./password.localonly.txt")

  resource_groups = {
    "onprem" = {}
  }

  virtual_networks = {
    "onprem" = {
      address_space = ["10.1.0.0/16"]
      subnets = {
        "dc"   = ["10.1.0.0/24"]
        "test" = ["10.1.1.0/24"]
      }
    }
  }

  vms = {
    "dc-01" = {
      subnet_key = "onprem-dc"
      rg_key     = "onprem"
      private_id = "10.1.0.4"
    }

    "test-01" = {
      subnet_key = "onprem-test"
      rg_key     = "onprem"
      private_id = "10.1.1.4"
    }
  }
}
