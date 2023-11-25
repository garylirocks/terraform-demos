variable "vhub_bgp_settings" {
  type        = any
  description = "BGP settings of the VPN Gateway in vHub"
}

variable "shared_key" {
  type        = string
  description = "BGP settings of the VPN Gateway in vHub"
}

resource "azurerm_public_ip" "vnet-gateway" {
  name                = "pip-vpng-demo-001"
  location            = var.region
  resource_group_name = azurerm_resource_group.demo.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "demo" {
  name                = "vpng-demo-001"
  location            = var.region
  resource_group_name = azurerm_resource_group.demo.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "default"
    public_ip_address_id          = azurerm_public_ip.vnet-gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.all["GatewaySubnet"].id
  }

  bgp_settings {
    asn = "64456" # can't be 65515, which will be used by Azure Virtual WAN.
  }
}

output "bgp" {
  value = azurerm_virtual_network_gateway.demo.bgp_settings
}

# Local network gateway represents the VPN gateway in vHub
resource "azurerm_local_network_gateway" "all" {
  for_each            = var.vhub_bgp_settings
  name                = "lgw-demo-${each.key}"
  location            = var.region
  resource_group_name = azurerm_resource_group.demo.name
  gateway_address     = tolist(each.value.tunnel_ips)[1]
  bgp_settings {
    asn                 = 65515
    bgp_peering_address = tolist(each.value.default_ips)[0]
  }
}

resource "azurerm_virtual_network_gateway_connection" "vhub" {
  for_each            = var.vhub_bgp_settings
  name                = "vcn-vhub-${each.key}"
  location            = var.region
  resource_group_name = azurerm_resource_group.demo.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.demo.id
  local_network_gateway_id   = azurerm_local_network_gateway.all[each.key].id

  shared_key          = var.shared_key
  dpd_timeout_seconds = 45
}
