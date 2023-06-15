resource "azurerm_databricks_workspace" "web_auth" {
  name                = "dbw-web_auth_databricks_do_not_delete"
  resource_group_name = azurerm_resource_group.all["web_auth_databricks_do_not_delete"].name
  location            = local.location
  sku                 = "premium"

  managed_resource_group_name           = "rg-managed-web_auth_databricks_do_not_delete"
  public_network_access_enabled         = false
  network_security_group_rules_required = "NoAzureDatabricksRules"

  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = azurerm_virtual_network.all["hub"].id
    public_subnet_name                                   = "snet-web_auth_public"
    private_subnet_name                                  = "snet-web_auth_private"
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.abw-subnets["hub-web_auth_public"].id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.abw-subnets["hub-web_auth_private"].id
  }
}
