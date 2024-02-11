output "nic_public_ips" {
  description = "Public IP of NICs"
  value       = { for k, v in azurerm_public_ip.nic : k => v.ip_address }
}

output "lb_public_ips" {
  description = "Public IPs of the load balancer"
  value = {
    inbound  = azurerm_public_ip.lb_inbound.ip_address
    outbound = azurerm_public_ip.lb_outbound.ip_address
  }
}

output "nat_gateway_public_ip" {
  description = "Public IP of the NAT gateway"
  value       = azurerm_public_ip.nat_gateway.ip_address
}
