resource "azurerm_linux_virtual_machine" "vms" {
  for_each            = local.instances
  name                = "vm-${each.key}"
  resource_group_name = azurerm_resource_group.rg[each.key].name
  location            = azurerm_resource_group.rg[each.key].location
  size                = "Standard_B1s"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.nics[each.key].id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/downloads/azure-temp.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
