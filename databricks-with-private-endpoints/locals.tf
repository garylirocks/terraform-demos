locals {
  location = "australiaeast"

  web-auth-workspace = {
    name            = "dbw-web-auth-databricks"
    managed-rg-name = "rg-managed-web-auth-databricks"
  }

  rgs = {
    web-auth-databricks = {}
    databricks          = {}
    prod                = {}
    hub                 = {}
  }

  vnets = {
    "hub" = {
      vnet-address-space = ["10.0.0.0/16"]
      snets = {
        web-auth-private = ["10.0.0.0/28"]
        web-auth-public  = ["10.0.0.16/28"]
        web-auth-pep     = ["10.0.0.32/29"]
      }
    }
    "databricks" = {
      vnet-address-space = ["10.1.0.0/16"]
      snets = {
        private     = ["10.1.0.0/26"]
        public      = ["10.1.0.64/26"]
        backend-pep = ["10.1.0.128/29"]
      }
    }
    "prod" = {
      vnet-address-space = ["10.2.0.0/16"]
      snets = {
        vm           = ["10.2.0.0/25"]
        frontend-pep = ["10.2.0.128/29"]
      }
    }
  }

  // re-organize subnets to a map
  subnets = { for item in flatten([for key, value in local.vnets : [
    for snet-key, snet-value in value.snets : {
      full-key         = "${key}-${snet-key}"
      snet-key         = "${key}-${snet-key}"
      address-prefixes = snet-value
      vnet-key         = key
      rg-key           = key
    }]
  ]) : item.full-key => item }

  # peerings on spoke vnet, only one peering can have
  #   use-remote-src-gateway = true
  peerings = {
    "prod-to-hub" = {
      src-vnet-key = "prod"
    }
    "databricks-to-hub" = {
      src-vnet-key = "databricks"
    }
  }
}
