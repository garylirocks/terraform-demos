resource "azurerm_storage_account" "demo" {
  name                     = "tfdemogary001"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}

resource "azurerm_private_dns_zone" "demo" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "demo" {
  name                  = "link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.demo.name
  virtual_network_id    = azurerm_virtual_network.vnet-hub.id
  registration_enabled  = false
}

resource "azurerm_private_endpoint" "demo" {
  name                = "pe-tfdemopeaue001"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.spoke-infrastructure.id

  private_service_connection {
    name                           = "default"
    private_connection_resource_id = azurerm_storage_account.demo.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  // this is optional
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.demo.id]
  }
}
