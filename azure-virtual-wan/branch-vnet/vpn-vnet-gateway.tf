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
