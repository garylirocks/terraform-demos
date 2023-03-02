output "resource_group_name" {
  value = azurerm_resource_group.temp.name
}

output "subnet_id" {
  value = azurerm_subnet.endpoint.id
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.temp.id
}
