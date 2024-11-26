resource "azurerm_resource_group" "onprem" {
  name     = local.vnets.onprem.resource-group
  location = local.vnets.onprem.location
}

resource "azurerm_virtual_network" "onprem-vnet" {
  name                = "vnet-onprem"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name
  address_space       = local.vnets.onprem.address-space
}

resource "azurerm_subnet" "onprem-gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.onprem.name
  virtual_network_name = azurerm_virtual_network.onprem-vnet.name
  address_prefixes     = ["192.168.255.224/27"]
}

resource "azurerm_subnet" "onprem-management" {
  name                 = "snet-vm"
  resource_group_name  = azurerm_resource_group.onprem.name
  virtual_network_name = azurerm_virtual_network.onprem-vnet.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_public_ip" "onprem-pip" {
  name                = "pip-${local.vnets.onprem.prefix}"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "onprem-nic" {
  name                 = "nic-${local.vnets.onprem.prefix}"
  location             = azurerm_resource_group.onprem.location
  resource_group_name  = azurerm_resource_group.onprem.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.vnets.onprem.prefix
    subnet_id                     = azurerm_subnet.onprem-management.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.onprem-pip.id
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "onprem-nsg" {
  name                = "nsg-${local.vnets.onprem.prefix}"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

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
  subnet_id                 = azurerm_subnet.onprem-management.id
  network_security_group_id = azurerm_network_security_group.onprem-nsg.id
}

resource "azurerm_linux_virtual_machine" "vm-onprem" {
  name                = "vm-${local.vnets.onprem.prefix}"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name
  size                = local.vm_size
  admin_username      = local.vm_admin_username

  network_interface_ids = [azurerm_network_interface.onprem-nic.id]

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

resource "azurerm_public_ip" "onprem-vpn-gateway" {
  name                = "pip-${local.vnets.onprem.prefix}-vpn-gateway"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  sku               = "Standard"
  allocation_method = "Static"
}

resource "azurerm_virtual_network_gateway" "onprem" {
  name                = "vpng-onprem"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.onprem-vpn-gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.onprem-gateway-subnet.id
  }

  depends_on = [azurerm_public_ip.onprem-vpn-gateway]
}

resource "azurerm_local_network_gateway" "onprem-side" {
  name                = "lgw-onprem-side"
  resource_group_name = azurerm_resource_group.onprem.name
  location            = local.vnets.onprem.location

  gateway_address = azurerm_public_ip.hub-vpn-gateway.ip_address
  address_space   = local.vnets.hub.address-space
}

resource "azurerm_virtual_network_gateway_connection" "onprem-to-az" {
  name                = "vcn-onprem-to-az"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  type = "IPsec"

  virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem-side.id

  shared_key = local.vnets.hub.shared-key
}
