locals {
  name     = "lb-demo-001"
  location = "australiaeast"

  vnets = {
    "001" = {
      address_space           = ["10.0.0.0/16"]
      subnet_address_prefixes = ["10.0.0.0/24"]
    }
    "002" = {
      address_space           = ["10.1.0.0/16"]
      subnet_address_prefixes = ["10.1.0.0/24"]
    }
  }
}
