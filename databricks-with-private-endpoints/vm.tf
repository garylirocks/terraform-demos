resource "random_password" "password" {
  length  = 16
  special = true
}

resource "azurerm_public_ip" "pip-demo" {
  name                = "pip-demo"
  location            = azurerm_resource_group.all["prod"].location
  resource_group_name = azurerm_resource_group.all["prod"].name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic-demo" {
  name                 = "nic-demo"
  location             = azurerm_resource_group.all["prod"].location
  resource_group_name  = azurerm_resource_group.all["prod"].name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "ip-001"
    private_ip_address            = "10.2.0.4"
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.all["prod-vm"].id
    public_ip_address_id          = azurerm_public_ip.pip-demo.id
  }
}

resource "azurerm_windows_virtual_machine" "vm-demo" {
  name                  = "vm-windows-demo-001"
  location              = azurerm_resource_group.all["prod"].location
  resource_group_name   = azurerm_resource_group.all["prod"].name
  network_interface_ids = [azurerm_network_interface.nic-demo.id]
  size                  = "Standard_B2s"
  computer_name         = "vm-prod"

  admin_username = "AzureAdmin"
  admin_password = random_password.password.result

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

resource "azurerm_network_security_group" "demo" {
  name                = "nsg-testing"
  location            = azurerm_resource_group.all["prod"].location
  resource_group_name = azurerm_resource_group.all["prod"].name

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
