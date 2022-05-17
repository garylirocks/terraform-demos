locals {
  vnets = {
    # the one with `last` needs to be created last
    "a" = {
      address_space = ["10.0.0.0/16"]
    }
    "b" = {
      address_space = ["10.1.0.0/16"]
      last          = true
    }
    "c" = {
      address_space = ["10.2.0.0/16"]
    }
  }

  last_vnet_key   = [for k, v in local.vnets : k if lookup(v, "last", null) == true][0]
  other_vnet_keys = [for k, v in local.vnets : k if k != local.last_vnet_key]
}
