# Networks
resource "azurerm_virtual_network" "all" {
  for_each            = local.regions
  name                = "vnet-${each.key}-01"
  location            = azurerm_resource_group.all[each.key].location
  resource_group_name = azurerm_resource_group.all[each.key].name
  address_space       = each.value.vnet.address_space
  tags = {
    environment = local.environment_tag
  }
}

resource "azurerm_subnet" "workload" {
  for_each             = local.regions
  name                 = "snet-workload-01"
  resource_group_name  = azurerm_resource_group.all[each.key].name
  virtual_network_name = azurerm_virtual_network.all[each.key].name
  address_prefixes     = each.value.vnet.subnets.workload
}

resource "azurerm_subnet" "bastion" {
  for_each             = local.regions
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.all[each.key].name
  virtual_network_name = azurerm_virtual_network.all[each.key].name
  address_prefixes     = each.value.vnet.subnets.bastion
}

# NSGs
resource "azurerm_network_security_group" "all" {
  for_each            = local.regions
  name                = "nsg-workload-${each.key}-01"
  location            = azurerm_resource_group.all[each.key].location
  resource_group_name = azurerm_resource_group.all[each.key].name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = local.environment_tag
  }
}

# NSG Association
resource "azurerm_subnet_network_security_group_association" "all" {
  for_each                  = local.regions
  subnet_id                 = azurerm_subnet.workload[each.key].id
  network_security_group_id = azurerm_network_security_group.all[each.key].id
}
