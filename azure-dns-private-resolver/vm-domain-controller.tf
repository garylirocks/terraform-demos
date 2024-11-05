# // A shared NSG
# resource "azurerm_network_security_group" "vm" {
#   name                = "nsg-allow-rdp"
#   location            = local.location
#   resource_group_name = azurerm_resource_group.all["onprem"].name

#   security_rule {
#     name                       = "AllowAnyRDPInbound"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# resource "azurerm_network_interface_security_group_association" "all" {
#   for_each                  = local.vms
#   network_interface_id      = azurerm_network_interface.all[each.key].id
#   network_security_group_id = azurerm_network_security_group.vm.id
# }

resource "random_password" "password" {
  length  = 16
  special = true
}

output "windows-password" {
  sensitive = true
  value     = random_password.password.result
}

resource "azurerm_windows_virtual_machine" "dc" {
  name                  = "vm-dc-001"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.nics["on-prem"].id]
  size                  = "Standard_B2s"
  computer_name         = "vm-dc-001"

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

resource "azurerm_virtual_machine_extension" "install-dns" {
  name                 = "install-dns"
  virtual_machine_id   = azurerm_windows_virtual_machine.dc.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools; Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru; Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools; exit 0"
    }
SETTINGS
}
