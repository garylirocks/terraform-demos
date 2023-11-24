# Virtual Machines
#Create NICs and associate the Public IPs
resource "azurerm_network_interface" "all" {
  for_each            = local.regions
  name                = "nic-vm-${each.key}-001"
  location            = azurerm_resource_group.all[each.key].location
  resource_group_name = azurerm_resource_group.all[each.key].name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.workload[each.key].id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = local.environment_tag
  }
}

#Create VMs
resource "azurerm_linux_virtual_machine" "all" {
  for_each            = local.regions
  name                = "vm-${each.key}-001"
  resource_group_name = azurerm_resource_group.all[each.key].name
  location            = azurerm_resource_group.all[each.key].location
  size                = local.vmsize
  admin_username      = "AzureAdmin"

  network_interface_ids = [
    azurerm_network_interface.all[each.key].id,
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

  tags = {
    environment = local.environment_tag
  }

}
