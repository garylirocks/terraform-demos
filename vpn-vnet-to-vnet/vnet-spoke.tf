resource "azurerm_resource_group" "spoke" {
  name     = local.vnets.spoke.resource-group
  location = local.vnets.spoke.location
}

resource "azurerm_virtual_network" "spoke-vnet" {
  name                = "vnet-spoke"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  address_space       = local.vnets.spoke.address-space
}

resource "azurerm_subnet" "spoke-gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet.name
  address_prefixes     = ["192.168.255.224/27"]
}

resource "azurerm_subnet" "spoke-management" {
  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke-vnet.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_public_ip" "spoke-pip" {
  name                = "pip-${local.vnets.spoke.prefix}"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "spoke-nic" {
  name                 = "nic-${local.vnets.spoke.prefix}"
  location             = azurerm_resource_group.spoke.location
  resource_group_name  = azurerm_resource_group.spoke.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.vnets.spoke.prefix
    subnet_id                     = azurerm_subnet.spoke-management.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.spoke-pip.id
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "spoke-nsg" {
  name                = "nsg-${local.vnets.spoke.prefix}"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "management-nsg-association" {
  subnet_id                 = azurerm_subnet.spoke-management.id
  network_security_group_id = azurerm_network_security_group.spoke-nsg.id
}

resource "azurerm_linux_virtual_machine" "vm-spoke" {
  name                = "vm-${local.vnets.spoke.prefix}"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  size                = local.vm_size
  admin_username      = local.vm_admin_username

  network_interface_ids = [azurerm_network_interface.spoke-nic.id]

  admin_ssh_key {
    username   = local.vm_admin_username
    public_key = file("~/downloads/azure-test.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = local.vm_image.publisher
    offer     = local.vm_image.offer
    sku       = local.vm_image.sku
    version   = local.vm_image.version
  }
}

resource "azurerm_public_ip" "spoke-vpn-gateway" {
  name                = "pip-${local.vnets.spoke.prefix}-vpn-gateway"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  sku               = "Standard"
  allocation_method = "Static"
}

resource "azurerm_virtual_network_gateway" "spoke" {
  name                = "vpng-spoke"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.spoke-vpn-gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.spoke-gateway-subnet.id
  }

  depends_on = [azurerm_public_ip.spoke-vpn-gateway]
}

resource "azurerm_virtual_network_gateway_connection" "spoke-to-hub" {
  name                = "vcn-spoke-to-hub"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  type           = "Vnet2Vnet"
  routing_weight = 1

  virtual_network_gateway_id      = azurerm_virtual_network_gateway.spoke.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.hub.id

  shared_key = local.vnets.hub.shared-key
}
