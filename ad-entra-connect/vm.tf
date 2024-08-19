resource "azurerm_public_ip" "all" {
  for_each            = local.vms
  name                = "pip-${each.key}"
  location            = local.location
  resource_group_name = azurerm_resource_group.all[each.value.rg_key].name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "all" {
  for_each              = local.vms
  name                  = "nic-${each.key}"
  location              = local.location
  resource_group_name   = azurerm_resource_group.all[each.value.rg_key].name
  ip_forwarding_enabled = false

  ip_configuration {
    name                          = "ip-001"
    private_ip_address            = each.value.private_id
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.all[each.value.subnet_key].id
    public_ip_address_id          = azurerm_public_ip.all[each.key].id
  }
}

// A shared NSG
resource "azurerm_network_security_group" "vm" {
  name                = "nsg-allow-rdp"
  location            = local.location
  resource_group_name = azurerm_resource_group.all["onprem"].name

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

resource "azurerm_network_interface_security_group_association" "all" {
  for_each                  = local.vms
  network_interface_id      = azurerm_network_interface.all[each.key].id
  network_security_group_id = azurerm_network_security_group.vm.id
}

resource "azurerm_virtual_machine" "all" {
  for_each              = local.vms
  name                  = "vm-${each.key}"
  location              = local.location
  resource_group_name   = azurerm_resource_group.all[each.value.rg_key].name
  network_interface_ids = [azurerm_network_interface.all[each.key].id]
  vm_size               = "Standard_B2s"

  storage_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-${each.key}"
    caching           = "None" // NOTE: seems need to be None to promote this VM to be a DC
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm-${each.key}"
    admin_username = "gary"
    admin_password = local.password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}
