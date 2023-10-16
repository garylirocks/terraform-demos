output "resource_group_name" {
  value = azurerm_resource_group.temp.name
}

output "app_id" {
  value = azuread_application.kv-app.application_id
}

output "app_password" {
  value     = azuread_application_password.default.value
  sensitive = true
}

output "tenant_id" {
  value = data.azuread_client_config.current.tenant_id
}

output "keyvault_ids" {
  value = { for k, v in azurerm_key_vault.all : k => v.id }
}
