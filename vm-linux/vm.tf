resource "azurerm_public_ip" "demo" {
  name                = "pip-${local.name}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Basic" # Basic public ips are open by default, so no need for NSG
}

resource "azurerm_network_interface" "demo" {
  name                = "nic-${local.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "default"
    subnet_id                     = azurerm_subnet.demo.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo.id
    primary                       = true
  }
}

resource "azurerm_linux_virtual_machine" "demo" {
  name                = "vm-${local.name}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.demo.id
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
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-LVM"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "oms" {
  name                       = "OmsAgentForLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.demo.id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OmsAgentForLinux"
  type_handler_version       = "1.14"
  auto_upgrade_minor_version = true # install the latest minor version
  automatic_upgrade_enabled  = true

  settings = <<SETTINGS
    {
      "workspaceId": "${azurerm_log_analytics_workspace.demo.workspace_id}"
    }
  SETTINGS

  protected_settings = <<SETTINGS
    {
      "workspaceKey": "${azurerm_log_analytics_workspace.demo.primary_shared_key}"
    }
  SETTINGS
}
