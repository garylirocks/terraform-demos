resource "azurerm_databricks_workspace" "web-auth" {
  name                = local.web-auth-workspace.name
  resource_group_name = azurerm_resource_group.all["web-auth-databricks"].name
  location            = local.location
  sku                 = "premium"

  managed_resource_group_name           = local.web-auth-workspace.managed-rg-name
  public_network_access_enabled         = false
  network_security_group_rules_required = "NoAzureDatabricksRules"

  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = azurerm_virtual_network.all["hub"].id
    public_subnet_name                                   = "snet-hub-web-auth-public"
    private_subnet_name                                  = "snet-hub-web-auth-private"
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.abw-subnets["hub-web-auth-public"].id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.abw-subnets["hub-web-auth-private"].id
  }
}

resource "azurerm_private_endpoint" "browser-auth" {
  name                = "pep-browser-auth-australiaeast"
  location            = local.location
  resource_group_name = azurerm_resource_group.all["web-auth-databricks"].name
  subnet_id           = azurerm_subnet.all["hub-web-auth-pep"].id

  private_service_connection {
    name                           = "default"
    private_connection_resource_id = azurerm_databricks_workspace.web-auth.id
    is_manual_connection           = false
    subresource_names              = ["browser_authentication"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.databricks-shared.id]
  }
}

resource "azurerm_management_lock" "web-auth-databricks" {
  depends_on = [
    azurerm_private_endpoint.browser-auth
  ]
  name       = "lock-rg-web-auth-databricks"
  scope      = azurerm_resource_group.all["web-auth-databricks"].id
  lock_level = "CanNotDelete"
  notes      = "Do not delete resources here"
}
