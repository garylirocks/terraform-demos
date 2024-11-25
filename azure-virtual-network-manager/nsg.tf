# Apply an NSG to VM subnets
# Testing the deny rules could be overwritten by VNM security admin rules
resource "azurerm_network_security_group" "demo-001" {
  name                = "nsg-demo-001"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  security_rule {
    name                       = "deny-22"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "demo" {
  # Associate to workload subnets
  for_each                  = { for k, v in local.vnets : k => v if(k != "hub" && k != "admin") }
  subnet_id                 = azurerm_subnet.vm[each.key].id
  network_security_group_id = azurerm_network_security_group.demo-001.id
}
