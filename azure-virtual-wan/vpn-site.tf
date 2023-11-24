module "vpn-site" {
  count  = var.create_vpn_site ? 1 : 0
  source = "./branch-vnet/"

  region = "Australia East"
}

resource "azurerm_vpn_site" "demo" {
  count               = var.create_vpn_site ? 1 : 0
  name                = "vst-demo-001"
  location            = azurerm_resource_group.all["aue"].location
  resource_group_name = azurerm_resource_group.all["aue"].name
  virtual_wan_id      = azurerm_virtual_wan.demo.id
  device_vendor       = "azure-vpn-gateway"

  link {
    name          = "Link1"
    ip_address    = module.vpn-site[0].bgp[0].peering_addresses[0].tunnel_ip_addresses[0]
    provider_name = "Azure"
    speed_in_mbps = 50

    // TODO: should get values from module output
    bgp {
      asn             = module.vpn-site[0].bgp[0].asn
      peering_address = module.vpn-site[0].bgp[0].peering_addresses[0].default_addresses[0]
    }
  }
}
