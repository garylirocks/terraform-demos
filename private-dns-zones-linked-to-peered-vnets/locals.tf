locals {
  instances = {
    "a" = {
      vnet_address_space = ["10.0.0.0/16"]
      snet_address_space = ["10.0.1.0/24"]
      a_record_ip        = "1.1.1.1"
    }
    "b" = {
      vnet_address_space = ["10.1.0.0/16"]
      snet_address_space = ["10.1.1.0/24"]
      a_record_ip        = "2.2.2.2"
    }
  }
}
