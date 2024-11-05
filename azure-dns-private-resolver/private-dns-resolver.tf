resource "azurerm_private_dns_resolver" "test" {
  name                = "dnspr-test-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  virtual_network_id  = azurerm_virtual_network.vnets["hub"].id
}

resource "azurerm_subnet" "inbound" {
  name                 = "snet-inbound"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnets["hub"].name
  address_prefixes     = local.instances.hub.snet_inbound_address_space

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "test" {
  name                    = "in-test-001"
  private_dns_resolver_id = azurerm_private_dns_resolver.test.id
  location                = azurerm_private_dns_resolver.test.location

  ip_configurations {
    private_ip_allocation_method = "Static"
    subnet_id                    = azurerm_subnet.inbound.id
    private_ip_address           = local.instances.hub.inbound_endpoint_ip
  }
}

resource "azurerm_subnet" "outbound" {
  name                 = "snet-outbound"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnets["hub"].name
  address_prefixes     = local.instances.hub.snet_outbound_address_space

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

// no need to config IPs for outbound endpoint
resource "azurerm_private_dns_resolver_outbound_endpoint" "test" {
  name                    = "out-test-001"
  private_dns_resolver_id = azurerm_private_dns_resolver.test.id
  location                = azurerm_private_dns_resolver.test.location
  subnet_id               = azurerm_subnet.outbound.id
}

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "test" {
  name                                       = "dnsfrs-test-001"
  resource_group_name                        = azurerm_resource_group.rg.name
  location                                   = azurerm_resource_group.rg.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.test.id]
}

resource "azurerm_private_dns_resolver_forwarding_rule" "test" {
  name                      = "dnsfr-test-001"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.test.id
  domain_name               = "on-prem.example.com."
  enabled                   = true

  target_dns_servers {
    ip_address = "192.168.0.4"
    port       = 53
  }
}

resource "azurerm_private_dns_resolver_virtual_network_link" "hub" {
  name                      = "link-to-hub-vnet"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.test.id
  virtual_network_id        = azurerm_virtual_network.vnets["hub"].id
}
