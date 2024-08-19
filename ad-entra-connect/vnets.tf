#######################################################################
## Create Virtual Networks
#######################################################################

resource "azurerm_virtual_network" "all" {
  for_each            = local.virtual_networks
  name                = "vnet-${each.key}"
  location            = local.location
  resource_group_name = azurerm_resource_group.all[each.key].name
  address_space       = each.value.address_space

  # dns_servers = []
}

#######################################################################
## Create Subnets
#######################################################################

resource "azurerm_subnet" "all" {
  for_each = merge([
    for vnet_key, vnet_value in local.virtual_networks : {
      for subnet_key, subnet_value in vnet_value.subnets : "${vnet_key}-${subnet_key}" => {
        prefixes    = subnet_value
        subnet_name = subnet_key
        vnet_name   = vnet_key
      }
    }
  ]...)

  name                 = "subnet-${each.value.subnet_name}"
  resource_group_name  = azurerm_resource_group.all[each.value.vnet_name].name
  virtual_network_name = "vnet-${each.value.vnet_name}"
  address_prefixes     = each.value.prefixes
}
