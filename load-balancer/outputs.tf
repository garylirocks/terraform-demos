output "lb_public_ip" {
  description = "Public IP of the load balancer"
  value       = azurerm_public_ip.lb.ip_address
}
