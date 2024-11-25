resource "azurerm_public_ip" "all" {
  for_each            = { for k, v in local.vnets : k => v if !lookup(v, "internal_only", false) }
  name                = "pip-${each.key}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  allocation_method   = "Static"
  sku                 = "Basic" # Basic public ips are open by default, so no need for NSG
}

resource "azurerm_network_interface" "all" {
  for_each              = local.vnets
  name                  = "nic-${each.key}"
  resource_group_name   = azurerm_resource_group.demo.name
  location              = azurerm_resource_group.demo.location
  ip_forwarding_enabled = each.key == "hub" ? true : false

  ip_configuration {
    name                          = "default"
    subnet_id                     = azurerm_subnet.vm[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = try(azurerm_public_ip.all[each.key].id, null)
    primary                       = true
  }
}

resource "azurerm_linux_virtual_machine" "vms" {
  // create a Linux VM in each vNet
  for_each = local.vnets

  name                = "vm-${each.key}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.all[each.key].id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("./azure-test.localonly.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
