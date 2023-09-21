# virtual-wan Resources
# virtual-wan
resource "azurerm_virtual_wan" "demo" {
  name                = "vwan-lab-001"
  resource_group_name = azurerm_resource_group.all["aue"].name
  location            = azurerm_resource_group.all["aue"].location

  # Configuration
  office365_local_breakout_category = "OptimizeAndAllow"

  tags = {
    environment = local.environment_tag
  }
}

# vHubs
resource "azurerm_virtual_hub" "all" {
  for_each            = local.regions
  name                = "vhub-${each.key}-001"
  resource_group_name = azurerm_resource_group.all[each.key].name
  location            = azurerm_resource_group.all[each.key].location
  virtual_wan_id      = azurerm_virtual_wan.demo.id
  address_prefix      = each.value.vhub

  tags = {
    environment = local.environment_tag
  }
}

# vnet connection to vhub
resource "azurerm_virtual_hub_connection" "all" {
  for_each                  = local.regions
  name                      = "vhub-conn-workload-${each.key}"
  virtual_hub_id            = azurerm_virtual_hub.all[each.key].id
  remote_virtual_network_id = azurerm_virtual_network.all[each.key].id
}
