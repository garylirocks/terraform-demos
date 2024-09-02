// the resource what the endpoint points to
resource "azurerm_key_vault" "demo" {
  name                          = "kv-${local.name}"
  location                      = azurerm_resource_group.example.location
  resource_group_name           = azurerm_resource_group.example.name
  enabled_for_disk_encryption   = true
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled      = false
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  public_network_access_enabled = false
  enable_rbac_authorization     = true
}

resource "azurerm_role_assignment" "user" {
  scope                = azurerm_key_vault.demo.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "id-agw" {
  scope                = azurerm_key_vault.demo.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.example.principal_id
}

resource "azurerm_private_endpoint" "kv" {
  name                = "pep-${azurerm_key_vault.demo.name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = module.workload-subnet.id["snet-workload"]

  private_service_connection {
    name                           = "pep-connection-${azurerm_key_vault.demo.name}"
    private_connection_resource_id = azurerm_key_vault.demo.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }

  # private_dns_zone_group {
  #   name                 = "default"
  #   private_dns_zone_ids = ["/subscriptions/bf569a1d-0efb-4ae3-922c-41add5a8a89c/resourceGroups/rg-dummy-private-dns-zones/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  # }
}
