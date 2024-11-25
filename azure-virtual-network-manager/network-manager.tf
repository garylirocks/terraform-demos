data "azurerm_subscription" "current" {
}

resource "azurerm_network_manager" "demo" {
  name                = "vnm-demo-001"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  description         = "Demo network manager"

  scope {
    subscription_ids = [data.azurerm_subscription.current.id]
  }

  scope_accesses = ["Connectivity", "SecurityAdmin"] # "Routing" is not supported by Terraform yet, need to enable it manually in the Portal

  lifecycle {
    ignore_changes = [
      scope_accesses
    ]
  }
}

# add a group for all vnets
resource "azurerm_network_manager_network_group" "demo-001" {
  name               = "netgroup-001"
  network_manager_id = azurerm_network_manager.demo.id
}

resource "azurerm_network_manager_static_member" "all" {
  for_each                  = local.vnets
  name                      = each.key
  network_group_id          = azurerm_network_manager_network_group.demo-001.id
  target_virtual_network_id = azurerm_virtual_network.all[each.key].id
}

# add all spoke vNets to another group
resource "azurerm_network_manager_network_group" "spokes" {
  name               = "netgroup-spokes"
  network_manager_id = azurerm_network_manager.demo.id
}

resource "azurerm_network_manager_static_member" "spokes" {
  for_each                  = { for k, v in local.vnets : k => v if k != "hub" }
  name                      = each.key
  network_group_id          = azurerm_network_manager_network_group.spokes.id
  target_virtual_network_id = azurerm_virtual_network.all[each.key].id
}
