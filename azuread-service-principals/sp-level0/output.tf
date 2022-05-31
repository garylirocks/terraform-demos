output "application_id" {
  value = azuread_application.level0.application_id
}

output "application_password" {
  value     = azuread_application_password.level0.value
  sensitive = true
}
