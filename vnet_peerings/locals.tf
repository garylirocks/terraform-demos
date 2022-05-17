locals {
  vnets = {
    "hub-a" = {
      vnet_address_space = ["10.0.0.0/16"]
      snet_address_space = ["10.0.1.0/24"]
    }
    "hub-b" = {
      vnet_address_space = ["10.1.0.0/16"]
      snet_address_space = ["10.1.1.0/24"]
    }
    "spoke" = {
      vnet_address_space = ["10.2.0.0/16"]
      snet_address_space = ["10.2.1.0/24"]
    }
  }

  # peerings on spoke vnet, only one peering can have
  #   use_remote_src_gateway = true
  peerings = {
    "to-hub-a" = {
      dest_vnet_key          = "hub-a"
      use_remote_src_gateway = true
    }
    "to-hub-b" = {
      dest_vnet_key          = "hub-b"
      use_remote_src_gateway = false
    }
  }
}
