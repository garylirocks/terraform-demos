resource "random_id" "kv" {
  byte_length = 5
}

// the resource what the endpoint points to
resource "azurerm_key_vault" "demo" {
  name                        = "kv-${random_id.kv.hex}"
  location                    = local.location
  resource_group_name         = azurerm_resource_group.demo.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false
  sku_name                    = "standard"

  // for the logic app SAMI
  access_policy {
    tenant_id = azurerm_logic_app_workflow.example.identity[0].tenant_id
    object_id = azurerm_logic_app_workflow.example.identity[0].principal_id

    secret_permissions = [
      "Get",
    ]
  }

  // for the standard logic app SAMI
  access_policy {
    tenant_id = azurerm_logic_app_standard.demo.identity[0].tenant_id
    object_id = azurerm_logic_app_standard.demo.identity[0].principal_id

    secret_permissions = [
      "Get",
    ]
  }

  // for current user
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "Set", "List"
    ]
  }
}

resource "azurerm_key_vault_secret" "demo" {
  name         = "secret-002"
  value        = "QuickFox"
  key_vault_id = azurerm_key_vault.demo.id
}

resource "azurerm_private_endpoint" "kv" {
  name                = "pep-${azurerm_key_vault.demo.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.demo.name
  subnet_id           = azurerm_subnet.private-endpoints.id

  private_service_connection {
    name                           = "pep-connection-${azurerm_key_vault.demo.name}"
    private_connection_resource_id = azurerm_key_vault.demo.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.all["vault"].id]
  }
}
