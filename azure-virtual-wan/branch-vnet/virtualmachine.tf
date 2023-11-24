# Create NICs and associate the Public IPs
resource "azurerm_network_interface" "all" {
  name                = "nic-vm-${local.name}-001"
  location            = var.region
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.all["snet-workload"].id
    private_ip_address_allocation = "Dynamic"
  }
}

#Create VMs
resource "azurerm_linux_virtual_machine" "all" {
  name                = "vm-${local.name}-001"
  location            = var.region
  resource_group_name = azurerm_resource_group.demo.name
  size                = "Standard_B2s"
  admin_username      = "AzureAdmin"

  network_interface_ids = [
    azurerm_network_interface.all.id,
  ]

  admin_ssh_key {
    username   = "AzureAdmin"
    public_key = file("~/downloads/azure-test.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-LVM"
    version   = "latest"
  }
}
