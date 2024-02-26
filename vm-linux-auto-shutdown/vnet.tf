resource "azurerm_virtual_network" "demo" {
  address_space       = local.vnet.address_space
  location            = local.location
  name                = "vnet-${local.name}"
  resource_group_name = azurerm_resource_group.demo.name
}

resource "azurerm_subnet" "demo" {
  name                 = "snet-${local.name}"
  address_prefixes     = local.vnet.subnet_address_prefixes
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
}

resource "azurerm_network_security_group" "demo" {
  name                = "nsg-${local.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.demo.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "demo" {
  subnet_id                 = azurerm_subnet.demo.id
  network_security_group_id = azurerm_network_security_group.demo.id
}
