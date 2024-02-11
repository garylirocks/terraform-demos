# Create public IPs
resource "azurerm_public_ip" "nic" {
  for_each            = { for k, v in local.snets : k => v if v.vm.public_ip == true }
  name                = "pip-nic-${each.key}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create two IP configs per NIC for testing
# Primary IP config may have public IP
resource "azurerm_network_interface" "demo" {
  for_each            = local.snets
  name                = "nic-${each.value.snet_key}"
  location            = local.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "ipconfig-001"
    primary                       = true
    subnet_id                     = azapi_resource.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = try(azurerm_public_ip.nic[each.key].id, null)
  }

  ip_configuration {
    name                          = "ipconfig-002"
    primary                       = false
    subnet_id                     = azapi_resource.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "demo" {
  for_each            = local.snets
  name                = "vm-${each.value.snet_key}"
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
