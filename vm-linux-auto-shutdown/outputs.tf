output "vm_public_ip" {
  description = "Public IP of VM"
  value       = azurerm_linux_virtual_machine.demo.public_ip_address
}

output "vm_private_ips" {
  description = "Private IP of VM"
  value       = azurerm_linux_virtual_machine.demo.private_ip_address
}
