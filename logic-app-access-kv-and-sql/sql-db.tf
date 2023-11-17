resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_id" "sql" {
  byte_length = 5
}

resource "azurerm_mssql_server" "demo" {
  name                         = "sql-${random_id.sql.hex}"
  resource_group_name          = azurerm_resource_group.demo.name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = random_password.db.result
}

resource "azurerm_mssql_database" "test" {
  name           = "sqldb-test-001"
  server_id      = azurerm_mssql_server.demo.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "Basic"
  zone_redundant = false
  read_scale     = false
}

resource "azurerm_private_endpoint" "sql" {
  name                = "pep-${azurerm_mssql_server.demo.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.demo.name
  subnet_id           = azurerm_subnet.private-endpoints.id

  private_service_connection {
    name                           = "pep-connection-${azurerm_mssql_server.demo.name}"
    private_connection_resource_id = azurerm_mssql_server.demo.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.all["sqlServer"].id]
  }
}
