locals {
  location = "australiaeast"

  vnets = {
    "000" = {
      address_space = ["10.0.0.0/16"]
      snets = {
        "000" = {
          address_space = ["10.0.0.0/24"]
          nat_gateway   = false
          vm = {
            public_ip = true
            lb        = true
          }
        }
        "001" = {
          address_space = ["10.0.1.0/24"]
          nat_gateway   = true
          vm = {
            public_ip = false
            lb        = true
          }
        }
        "002" = {
          address_space = ["10.0.2.0/24"]
          nat_gateway   = true
          vm = {
            public_ip = true
            lb        = false
          }
        }
      }
    }
    # "001" = {
    #   address_space           = ["10.1.0.0/16"]
    #   subnet_address_prefixes = ["10.1.0.0/24"]
    # }
  }

  snets = merge([
    for vnet_key, vnet_value in local.vnets : {
      for snet_key, snet_value in vnet_value.snets : "${vnet_key}_${snet_key}" => merge(snet_value, {
        "vnet_key" = vnet_key
        "snet_key" = snet_key
    }) }
  ]...)
}
