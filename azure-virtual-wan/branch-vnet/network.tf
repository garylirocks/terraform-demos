variable "region" {
  type = string
}

locals {
  subnets = {
    GatewaySubnet      = ["172.16.0.0/24"]
    snet-workload      = ["172.16.1.0/24"]
    AzureBastionSubnet = ["172.16.2.0/24"]
  }
}

resource "azurerm_virtual_network" "vpn" {
  name                = "vnet-${local.name}-01"
  location            = var.region
  resource_group_name = azurerm_resource_group.demo.name
  address_space       = ["172.16.0.0/20"]
}

resource "azurerm_subnet" "all" {
  for_each             = local.subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.vpn.name
  address_prefixes     = each.value
}

# NSGs
resource "azurerm_network_security_group" "workload" {
  name                = "nsg-workload-aue-01"
  location            = var.region
  resource_group_name = azurerm_resource_group.demo.name

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
}

# NSG Association
resource "azurerm_subnet_network_security_group_association" "workload" {
  subnet_id                 = azurerm_subnet.all["snet-workload"].id
  network_security_group_id = azurerm_network_security_group.workload.id
}
