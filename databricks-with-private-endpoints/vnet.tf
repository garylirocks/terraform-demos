resource "azurerm_virtual_network" "all" {
  for_each            = local.vnets
  address_space       = each.value.vnet-address-space
  location            = local.location
  name                = "vnet-${each.key}"
  resource_group_name = azurerm_resource_group.all[each.key].name
}

resource "azurerm_subnet" "all" {
  for_each = local.subnets

  name                 = "snet-${each.value.snet-key}"
  address_prefixes     = each.value.address-prefixes
  resource_group_name  = azurerm_resource_group.all[each.value.rg-key].name
  virtual_network_name = azurerm_virtual_network.all[each.value.vnet-key].name

  // add delegation for the public/private subnets
  dynamic "delegation" {
    for_each = try(regex("public|private", each.value.snet-key), null) != null ? [1] : []

    content {
      name = "delegation-to-databricks"
      service_delegation {
        name = "Microsoft.Databricks/workspaces"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
        ]
      }
    }
  }
}

module "azure-vnet-peering" {
  source  = "claranet/vnet-peering/azurerm"
  version = "5.0.1"

  for_each = local.peerings

  providers = {
    azurerm.src = azurerm
    azurerm.dst = azurerm
  }

  vnet_src_id  = azurerm_virtual_network.all[each.value.src-vnet-key].id
  vnet_dest_id = azurerm_virtual_network.all["hub"].id

  allow_forwarded_src_traffic  = false
  allow_forwarded_dest_traffic = false

  allow_virtual_src_network_access  = true
  allow_virtual_dest_network_access = true

  use_remote_src_gateway  = false
  use_remote_dest_gateway = false

  allow_gateway_src_transit  = false
  allow_gateway_dest_transit = false
}


# an empty NSG to associate to the workspace public/private subnets
resource "azurerm_network_security_group" "empty" {
  name                = "nsg-abw-empty"
  location            = local.location
  resource_group_name = azurerm_resource_group.all["hub"].name
}

resource "azurerm_subnet_network_security_group_association" "abw-subnets" {
  for_each = { for key, value in local.subnets : key => value if try(regex("public|private", value.snet-key), null) != null }

  subnet_id                 = azurerm_subnet.all[each.value.full-key].id
  network_security_group_id = azurerm_network_security_group.empty.id
}
