resource "random_id" "storage_account" {
  byte_length = 5
}

resource "azurerm_storage_account" "demo" {
  name                     = "st${random_id.storage_account.hex}"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # CAUTION: this needs to be true for creating the Standard Logic App
  public_network_access_enabled = false

  network_rules {
    default_action = "Deny"
  }
}

resource "azurerm_private_endpoint" "storage-services" {
  for_each            = toset(["blob", "file", "queue", "table"]) # need to enable all sub services
  name                = "pep-${azurerm_storage_account.demo.name}-${each.key}"
  location            = local.location
  resource_group_name = azurerm_resource_group.demo.name
  subnet_id           = azurerm_subnet.private-endpoints.id

  private_service_connection {
    name                           = "pep-connection-${azurerm_storage_account.demo.name}-${each.key}"
    private_connection_resource_id = azurerm_storage_account.demo.id
    is_manual_connection           = false
    subresource_names              = [each.key]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.all[each.key].id]
  }
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_storage_account.demo.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_logic_app_standard.demo.identity[0].principal_id
}
