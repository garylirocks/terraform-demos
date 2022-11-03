#######################################################################
## Create Virtual Networks
#######################################################################

resource "azurerm_virtual_network" "vnet-hub" {
  name                = "vnet-hub"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]

  // NOTE: this needs to be changed to 10.0.0.4 manually, so ignore the change here
  dns_servers = [local.dns-ip]
}

#######################################################################
## Create Subnets
#######################################################################

resource "azurerm_subnet" "AzureBastionSubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_subnet" "subnet-hub-dns" {
  name                 = "subnet-hub-dns"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.0.0/24"]
}

#######################################################################
## Create Public IPs
#######################################################################

resource "azurerm_public_ip" "pip-hub-bastion" {
  name                = "pip-hub-bastion"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#######################################################################
## Create Bastion Services
#######################################################################

resource "azurerm_bastion_host" "bas-hub" {
  name                = "bas-hub"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "bas-hub"
    subnet_id            = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.pip-hub-bastion.id
  }
}

#######################################################################
## Create Network Interface
#######################################################################

resource "azurerm_network_interface" "nic-dns" {
  name                 = "nic-dns"
  location             = var.location
  resource_group_name  = azurerm_resource_group.main.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "nic-dns"
    private_ip_address            = local.dns-ip
    subnet_id                     = azurerm_subnet.subnet-hub-dns.id
    private_ip_address_allocation = "Static"
  }
}

#######################################################################
## Create Virtual Machine
#######################################################################

resource "azurerm_virtual_machine" "vm-dns" {
  name                  = "vm-dns"
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.nic-dns.id]
  vm_size               = var.vmsize

  storage_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-dns"
    caching           = "None" // NOTE: seems need to be None to promote this VM to be a DC
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm-dns"
    admin_username = var.username
    admin_password = local.password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

#######################################################################
## Create VNet Peering
#######################################################################

resource "azurerm_virtual_network_peering" "hub-spoke-peer" {
  name                         = "hub-spoke-peer"
  resource_group_name          = azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.vnet-hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [azurerm_virtual_network.vnet-spoke, azurerm_virtual_network.vnet-hub]
}


resource "azurerm_virtual_network_peering" "spoke-hub-peer" {
  name                      = "spoke-hub-peer"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.vnet-spoke.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  depends_on                   = [azurerm_virtual_network.vnet-spoke, azurerm_virtual_network.vnet-hub]
}
