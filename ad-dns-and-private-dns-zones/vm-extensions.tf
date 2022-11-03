resource "azurerm_virtual_machine_extension" "install-dns" {
  name                 = "install-dns"
  virtual_machine_id   = azurerm_virtual_machine.vm-dns.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools; Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru; Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools; exit 0"
    }
SETTINGS
}
