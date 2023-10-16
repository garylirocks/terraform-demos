locals {
  location = "Australia East"
  vaults = {
    rbac = {
      enable_rbac_authorization = true
    }
    policy = {
      enable_rbac_authorization = false
    }
  }
}

data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "temp" {
  name     = "rg-kv-temp-001"
  location = local.location
}

resource "azurerm_key_vault" "all" {
  for_each                    = local.vaults
  name                        = "kv-${each.key}-temp-001"
  location                    = local.location
  resource_group_name         = azurerm_resource_group.temp.name
  tenant_id                   = data.azuread_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false
  enabled_for_disk_encryption = true
  enable_rbac_authorization   = each.value.enable_rbac_authorization
}

resource "random_pet" "default" {
  length = 2
}

# assign current user a role on the KV with RBAC permission model
resource "azurerm_role_assignment" "user" {
  scope                = azurerm_key_vault.all["rbac"].id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azuread_client_config.current.object_id
}

resource "azurerm_key_vault_access_policy" "user" {
  key_vault_id = azurerm_key_vault.all["policy"].id
  tenant_id    = data.azuread_client_config.current.tenant_id
  object_id    = data.azuread_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete"
  ]
}

resource "azurerm_key_vault_secret" "example" {
  # permissions need to be sorted first
  depends_on = [
    azurerm_role_assignment.user,
    azurerm_key_vault_access_policy.user,
  ]
  for_each     = local.vaults
  name         = "top-secret"
  value        = random_pet.default.id
  key_vault_id = azurerm_key_vault.all[each.key].id
}
