resource "random_integer" "ri" {
  min = 10001
  max = 99999
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "cosmos-db-${random_integer.ri.result}"
  location            = azurerm_resource_group.temp.location
  resource_group_name = azurerm_resource_group.temp.name
  offer_type          = "Standard"
  enable_free_tier    = true

  enable_automatic_failover = false

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = azurerm_resource_group.temp.location
    failover_priority = 0
  }
}

resource "azurerm_private_endpoint" "cosmos" {
  name                = "pep-cosmos-db-${random_integer.ri.result}"
  location            = azurerm_resource_group.temp.location
  resource_group_name = azurerm_resource_group.temp.name
  subnet_id           = azurerm_subnet.endpoint.id

  // you can customise the NIC name
  custom_network_interface_name = "nic-pep-cosmos-db-${random_integer.ri.result}"

  private_service_connection {
    name                           = "default"
    private_connection_resource_id = azurerm_cosmosdb_account.db.id
    is_manual_connection           = false
    subresource_names              = ["Sql"]
  }

  ip_configuration {
    name               = "ip-config-01"
    private_ip_address = "10.0.1.11"
    subresource_name   = "Sql"
    member_name        = "cosmos-db-${random_integer.ri.result}"
  }

  ip_configuration {
    name               = "ip-config-02"
    private_ip_address = "10.0.1.12"
    subresource_name   = "Sql"
    member_name        = "cosmos-db-${random_integer.ri.result}-${azurerm_resource_group.temp.location}"
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.temp.id]
  }
}
