# Azure Firewall
resource "azurerm_firewall" "all" {
  for_each            = var.create_firewall ? local.regions : {}
  name                = "afw-${each.key}-001"
  location            = azurerm_resource_group.all[each.key].location
  resource_group_name = azurerm_resource_group.all[each.key].name
  sku_tier            = "Basic"
  sku_name            = "AZFW_Hub"
  firewall_policy_id  = azurerm_firewall_policy.demo[0].id

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.all[each.key].id
    public_ip_count = 1
  }
}

# Azure Firewall Policy
resource "azurerm_firewall_policy" "demo" {
  count               = var.create_firewall ? 1 : 0
  name                = "afwp-001"
  resource_group_name = azurerm_resource_group.all["aue"].name
  location            = azurerm_resource_group.all["aue"].location
  sku                 = "Basic"
}

# Azure Firewall Policy Rule Collection Group
resource "azurerm_firewall_policy_rule_collection_group" "demo" {
  count              = var.create_firewall ? 1 : 0
  name               = "afwp-group-001"
  firewall_policy_id = azurerm_firewall_policy.demo[0].id
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

resource "azurerm_virtual_hub_routing_intent" "all" {
  for_each       = var.create_firewall ? local.regions : {}
  name           = "routingintent-${each.key}"
  virtual_hub_id = azurerm_virtual_hub.all[each.key].id

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.all[each.key].id
  }

  routing_policy {
    name         = "PrivateTrafficPolicy"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.all[each.key].id
  }
}
