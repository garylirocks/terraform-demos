locals {
  location = "Australia East"

  vnets = {
    hub = {
      vnet_address_space = "10.0.0.0/16"
    }
    "admin" = {
      vnet_address_space = "10.1.0.0/16"
    }
    "work-01" = {
      vnet_address_space = "10.16.0.0/16"
      internal_only      = true
    }
    "work-02" = {
      vnet_address_space = "10.17.0.0/16"
      internal_only      = true
    }
  }
}
