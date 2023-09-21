locals {
  regions = {
    "aue" = {
      "name" = "Australia East"
      "vhub" = "10.1.0.0/24"
      "vnet" = {
        "name"          = "vnet1"
        "address_space" = ["10.1.1.0/24"]
        "subnets" = {
          "workload" = ["10.1.1.0/26"]
          "bastion"  = ["10.1.1.64/26"]
        }
      }
    }
    "ause" = {
      "name" = "Australia Southeast"
      "vhub" = "10.2.0.0/24"
      "vnet" = {
        "name"          = "vnet1"
        "address_space" = ["10.2.1.0/24"]
        "subnets" = {
          "workload" = ["10.2.1.0/26"]
          "bastion"  = ["10.2.1.64/26"]
        }
      }
    }
  }

  environment_tag = "vwan-lab"

  # VMs
  vmsize        = "Standard_B2s"
  adminusername = "AzureAdmin"

  # Optional - Firewalls
  azfw = false
}
