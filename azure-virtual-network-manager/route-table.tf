# Creates a route table
# And see what happens when we deploy an AVNM routing configuration on the same vNet/subnet

resource "azurerm_route_table" "demo" {
  name                = "rt-demo-001"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  route {
    name                   = "udr-001"
    address_prefix         = "10.16.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.0.99" # doesn't exist
  }

  route {
    name                   = "udr-002"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.0.99" # doesn't exist
  }
}

resource "azurerm_subnet_route_table_association" "demo" {
  subnet_id      = azurerm_subnet.vm["admin"].id
  route_table_id = azurerm_route_table.demo.id
}
