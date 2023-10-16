resource "azuread_application" "kv-app" {
  display_name = "sp-kv-app"
  owners = [
    data.azuread_client_config.current.object_id,
  ]
}

resource "azuread_service_principal" "kv-app" {
  application_id = azuread_application.kv-app.application_id
  owners = [
    data.azuread_client_config.current.object_id,
  ]
}

resource "azuread_application_password" "default" {
  application_object_id = azuread_application.kv-app.object_id
}

##########
# permissions for the service principal
##########
# CAUTION: To read a secret value from a KV, this "Key Vault Reader" is required when using Terraform, not when using the Azure CLI
resource "azurerm_role_assignment" "sp-kv-reader" {
  for_each             = azurerm_key_vault.all
  scope                = each.value.id
  role_definition_name = "Key Vault Reader"
  principal_id         = azuread_service_principal.kv-app.object_id
}

resource "azurerm_role_assignment" "sp" {
  # only scope to the secret, not the whole KV
  scope                = azurerm_key_vault_secret.example["rbac"].resource_versionless_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.kv-app.object_id
}

resource "azurerm_key_vault_access_policy" "sp" {
  key_vault_id = azurerm_key_vault.all["policy"].id
  tenant_id    = data.azuread_client_config.current.tenant_id
  object_id    = azuread_service_principal.kv-app.object_id

  secret_permissions = [
    "Get"
  ]
}
