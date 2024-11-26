resource "azurerm_resource_group" "hub" {
  name     = local.vnets.hub.resource-group
  location = local.vnets.hub.location
}

resource "azurerm_virtual_network" "hub-vnet" {
  name                = "vnet-${local.vnets.hub.prefix}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = local.vnets.hub.address-space
}

resource "azurerm_subnet" "hub-gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.255.224/27"]
}

resource "azurerm_subnet" "hub-management" {
  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "hub-nic" {
  name                 = "nic-${local.vnets.hub.prefix}"
  location             = azurerm_resource_group.hub.location
  resource_group_name  = azurerm_resource_group.hub.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.vnets.hub.prefix
    subnet_id                     = azurerm_subnet.hub-management.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm-hub" {
  name                  = "vm-${local.vnets.hub.prefix}"
  location              = azurerm_resource_group.hub.location
  resource_group_name   = azurerm_resource_group.hub.name
  size                  = local.vm_size
  admin_username        = local.vm_admin_username
  network_interface_ids = [azurerm_network_interface.hub-nic.id]

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

# Virtual Network Gateway
resource "azurerm_public_ip" "hub-vpn-gateway" {
  name                = "pip-hub-vpn-gateway"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  sku               = "Standard"
  allocation_method = "Static"
}

resource "azurerm_virtual_network_gateway" "hub" {
  name                = "vpng-hub"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hub-vpn-gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub-gateway-subnet.id
  }
  depends_on = [azurerm_public_ip.hub-vpn-gateway]
}

resource "azurerm_local_network_gateway" "az-side" {
  name                = "lgw-az-side"
  resource_group_name = azurerm_resource_group.hub.name
  location            = local.vnets.hub.location

  gateway_address = azurerm_public_ip.onprem-vpn-gateway.ip_address
  address_space   = local.vnets.onprem.address-space
}

resource "azurerm_virtual_network_gateway_connection" "az-to-onprem" {
  name                = "vcn-az-to-onprem"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  type = "IPsec"

  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub.id
  local_network_gateway_id   = azurerm_local_network_gateway.az-side.id

  shared_key = local.vnets.hub.shared-key
}
