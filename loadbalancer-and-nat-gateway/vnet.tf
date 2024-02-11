resource "azurerm_virtual_network" "demo" {
  for_each            = local.vnets
  name                = "vnet-${each.key}"
  address_space       = each.value.address_space
  location            = local.location
  resource_group_name = azurerm_resource_group.demo.name
}

# resource "azurerm_subnet" "demo" {
#   ...
# }

## NOTE
## "azurerm_subnet" resource does not support "defaultOutboundAccess" property yet
## so we use azapi to create this subnet
resource "azapi_resource" "subnet" {
  for_each  = local.snets
  type      = "Microsoft.Network/virtualNetworks/subnets@2023-06-01"
  name      = "snet-${each.value.snet_key}"
  parent_id = azurerm_virtual_network.demo[each.value.vnet_key].id

  body = jsonencode({
    properties = {
      addressPrefixes       = each.value.address_space
      defaultOutboundAccess = false
    }
  })
}

resource "azurerm_network_security_group" "demo" {
  name                = "nsg-001"
  location            = local.location
  resource_group_name = azurerm_resource_group.demo.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "web"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "demo" {
  for_each                  = local.snets
  subnet_id                 = azapi_resource.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.demo.id
}
