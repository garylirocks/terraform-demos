resource "random_pet" "name" {
}

resource "azurerm_resource_group" "example" {
  name     = "rg-app-${local.name}-001"
  location = local.region
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-${local.name}-001"
  resource_group_name = azurerm_resource_group.example.name
  location            = local.region
  address_space       = ["10.0.0.0/24"]

  subnet {
    name           = "snet-workload"
    address_prefix = "10.0.0.0/26"
  }

  subnet {
    name           = "snet-agw"
    address_prefix = "10.0.0.64/26"
  }
}

output "temp" {
  value = azurerm_virtual_network.example

}
