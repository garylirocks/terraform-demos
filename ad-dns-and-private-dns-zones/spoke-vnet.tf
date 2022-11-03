#######################################################################
## Create Virtual Networks
#######################################################################

resource "azurerm_virtual_network" "vnet-spoke" {
  name                = "vnet-spoke"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.1.0.0/16"]
  dns_servers         = [local.dns-ip]
}

resource "azurerm_subnet" "spoke-infrastructure" {
  name                 = "subnet-test"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = ["10.1.0.0/24"]
}

#######################################################################
## Create Network Interface
#######################################################################

resource "azurerm_network_interface" "nic-test" {
  name                 = "nic-test"
  location             = var.location
  resource_group_name  = azurerm_resource_group.main.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "nic-test"
    subnet_id                     = azurerm_subnet.spoke-infrastructure.id
    private_ip_address_allocation = "Dynamic"
  }
}

#######################################################################
## Create Virtual Machine
#######################################################################

resource "azurerm_virtual_machine" "vm-test" {
  name                  = "vm-test"
  location              = var.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.nic-test.id]
  vm_size               = var.vmsize

  storage_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-test"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm-test"
    admin_username = var.username
    admin_password = local.password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}
