locals {
  name     = "linux-vm-demo-001"
  location = "australiaeast"
  vnet = {
    address_space           = ["10.2.0.0/16"]
    subnet_address_prefixes = ["10.2.0.0/24"]
  }
}
