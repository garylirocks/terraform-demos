output "password" {
  value     = random_password.password.result
  sensitive = true
}

output "vm_public_ip" {
  description = "Public IP of VM"
  value       = azurerm_windows_virtual_machine.vm-demo.public_ip_address
}
