# A branch site (mocked as a vnet)
module "branch" {
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
    ip_address    = module.branch[0].bgp[0].peering_addresses[0].tunnel_ip_addresses[0]
    provider_name = "Azure"
    speed_in_mbps = 50

    // TODO: should get values from module output
    bgp {
      asn             = module.branch[0].bgp[0].asn
      peering_address = module.branch[0].bgp[0].peering_addresses[0].default_addresses[0]
    }
  }
}

# VPN gateway in a vHub
resource "azurerm_vpn_gateway" "vhub-aue-001" {
  count               = var.create_vpn_site ? 1 : 0
  name                = "vpng-vhub-aue-001"
  location            = azurerm_resource_group.all["aue"].location
  resource_group_name = azurerm_resource_group.all["aue"].name
  virtual_hub_id      = azurerm_virtual_hub.all["aue"].id

  bgp_settings {
    asn         = 65515
    peer_weight = 0

    instance_0_bgp_peering_address {
      custom_ips = []
    }

    instance_1_bgp_peering_address {
      custom_ips = []
    }
  }
}

resource "azurerm_vpn_gateway_connection" "demo" {
  count              = var.create_vpn_site ? 1 : 0
  name               = "vcn-branch-001"
  vpn_gateway_id     = azurerm_vpn_gateway.vhub-aue-001[0].id
  remote_vpn_site_id = azurerm_vpn_site.demo[0].id

  vpn_link {
    name             = "Link1"
    vpn_site_link_id = azurerm_vpn_site.demo[0].link[0].id
  }
}
