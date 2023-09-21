# Azure Firewall
resource "azurerm_firewall" "all" {
  for_each            = local.regions
  name                = "afw-${each.key}-001"
  location            = azurerm_resource_group.all[each.key].location
  resource_group_name = azurerm_resource_group.all[each.key].name
  sku_tier            = "Standard"
  sku_name            = "AZFW_Hub"
  firewall_policy_id  = azurerm_firewall_policy.demo.id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.all[each.key].id
    public_ip_count = 1
  }
}

# Azure Firewall Policy
resource "azurerm_firewall_policy" "demo" {
  name                = "afwp-001"
  resource_group_name = azurerm_resource_group.all["aue"].name
  location            = azurerm_resource_group.all["aue"].location
}

# Azure Firewall Policy Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "demo" {
  name               = "afwp-group-001"
  firewall_policy_id = azurerm_firewall_policy.demo.id
  priority           = 100

  network_rule_collection {
    name     = "network_rule_collection_1"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "rule_1"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }
}
