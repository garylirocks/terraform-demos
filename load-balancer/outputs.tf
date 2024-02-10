output "lb_public_ip_inbound" {
  description = "Public IP of the load balancer"
  value       = azurerm_public_ip.lb_inbound.ip_address
}

output "lb_public_ip_outbound" {
  description = "Public IP of the load balancer"
  value       = azurerm_public_ip.lb_outbound.ip_address
}
