resource "azurerm_public_ip" "pip-shir" {
  name                = "pip-shir"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic-shir" {
  name                 = "nic-shir"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "ip-001"
    private_ip_address            = "10.0.0.8"
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.subnet-default.id
    public_ip_address_id          = azurerm_public_ip.pip-shir.id
  }
}

resource "azurerm_virtual_machine" "vm-shir" {
  name                  = "vm-windows-shir-001"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.nic-shir.id]
  vm_size               = "Standard_B2s"

  storage_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-shir"
    caching           = "None" // NOTE: seems need to be None to promote this VM to be a DC
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm-shir"
    admin_username = "AzureAdmin"
    admin_password = file("./password.localonly.txt")
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

resource "azurerm_network_security_group" "shir" {
  name                = "nsg-testing"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

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

resource "azurerm_network_interface_security_group_association" "shir" {
  network_interface_id      = azurerm_network_interface.nic-shir.id
  network_security_group_id = azurerm_network_security_group.shir.id
}
