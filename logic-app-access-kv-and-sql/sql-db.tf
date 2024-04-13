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

  azuread_administrator {
    azuread_authentication_only = false
    login_username              = data.azuread_user.current_user.user_principal_name
    object_id                   = data.azurerm_client_config.current.object_id
  }
}

locals {
  logic_app_outbound_ips = {
    // Logic APP outgoing IPs
    "13.75.149.4"    = ["13.75.149.4", "13.75.149.4"],
    "104.210.91.55"  = ["104.210.91.55", "104.210.91.55"],
    "104.210.90.241" = ["104.210.90.241", "104.210.90.241"],
    "52.187.227.245" = ["52.187.227.245", "52.187.227.245"],
    "52.187.226.96"  = ["52.187.226.96", "52.187.226.96"],
    "52.187.231.184" = ["52.187.231.184", "52.187.231.184"],
    "52.187.229.130" = ["52.187.229.130", "52.187.229.130"],
    "52.187.226.139" = ["52.187.226.139", "52.187.226.139"],
    "20.53.93.188"   = ["20.53.93.188", "20.53.93.188"],
    "20.53.72.170"   = ["20.53.72.170", "20.53.72.170"],
    "20.53.107.208"  = ["20.53.107.208", "20.53.107.208"],
    "20.53.106.182"  = ["20.53.106.182", "20.53.106.182"],
    // Shared connector outgoing IPs
    "52.237.214.72" = ["52.237.214.72", "52.237.214.72"],
    "13.72.243.10"  = ["13.72.243.10", "13.72.243.10"],
    "13.70.72.192"  = ["13.70.72.192", "13.70.72.207"],
    "13.70.78.224"  = ["13.70.78.224", "13.70.78.255"],
    "20.70.220.224" = ["20.70.220.224", "20.70.220.239"],
    "20.70.220.192" = ["20.70.220.192", "20.70.220.223"],
    "20.213.202.84" = ["20.213.202.84", "20.213.202.84"],
    "20.213.202.51" = ["20.213.202.51", "20.213.202.51"],
  }
}

// Logic app IPs
resource "azurerm_mssql_firewall_rule" "logic-app-ips" {
  for_each         = local.logic_app_outbound_ips
  name             = each.key
  server_id        = azurerm_mssql_server.demo.id
  start_ip_address = each.value[0]
  end_ip_address   = each.value[1]
}


// allow my IP for easier operation
resource "azurerm_mssql_firewall_rule" "my-ip" {
  name             = "my-ip"
  server_id        = azurerm_mssql_server.demo.id
  start_ip_address = data.http.ip.response_body
  end_ip_address   = data.http.ip.response_body
}

resource "azurerm_mssql_database" "test" {
  name           = "sqldb-test-001"
  server_id      = azurerm_mssql_server.demo.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "Basic"
  zone_redundant = false
  read_scale     = false

  // load sample data
  sample_name = "AdventureWorksLT"
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
