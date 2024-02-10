resource "azurerm_network_interface" "demo" {
  for_each            = local.vnets
  name                = "nic-${each.key}"
  location            = local.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "default"
    subnet_id                     = azapi_resource.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }

  ip_configuration {
    name                          = "ipconfig-2"
    subnet_id                     = azapi_resource.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    primary                       = false
  }
}

resource "azurerm_linux_virtual_machine" "demo" {
  for_each            = local.vnets
  name                = "vm-${each.key}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = local.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.demo[each.key].id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/downloads/azure-test.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}
