resource "azurerm_public_ip" "pip-demo" {
  name                = "pip-demo"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic-demo" {
  name                = "nic-demo"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "ip-001"
    private_ip_address            = "10.1.1.8"
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.subnet-default.id
    public_ip_address_id          = azurerm_public_ip.pip-demo.id
  }
}

resource "azurerm_virtual_machine" "vm-demo" {
  name                  = "vm-windows-demo-001"
  location              = azurerm_resource_group.demo.location
  resource_group_name   = azurerm_resource_group.demo.name
  network_interface_ids = [azurerm_network_interface.nic-demo.id]
  vm_size               = "Standard_B2s"

  storage_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-demo"
    caching           = "None" // NOTE: seems need to be None to promote this VM to be a DC
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm-demo"
    admin_username = "AzureAdmin"
    admin_password = file("./password.localonly.txt")
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

resource "azurerm_network_security_group" "demo" {
  name                = "nsg-testing"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  security_rule {
    name                       = "AllowAnyRDPInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "demo" {
  network_interface_id      = azurerm_network_interface.nic-demo.id
  network_security_group_id = azurerm_network_security_group.demo.id
}
