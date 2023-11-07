locals {
  name   = "test-${random_pet.name.id}"
  region = "Australia East"

  subnets = {
    agw      = [for snet in azurerm_virtual_network.example.subnet : snet if snet.name == "snet-agw"][0]
    workload = [for snet in azurerm_virtual_network.example.subnet : snet if snet.name == "snet-workload"][0]
  }
}
