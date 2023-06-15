locals {
  name     = "databricks-001"
  location = "australiaeast"

  rgs = {
    web_auth_databricks_do_not_delete = {}
    databricks                        = {}
    prod                              = {}
    hub                               = {}
  }

  vnets = {
    "hub" = {
      vnet_address_space = ["10.0.0.0/16"]
      snets = {
        web_auth_private = ["10.0.0.0/29"]
        web_auth_public  = ["10.0.0.8/29"]
        web_auth_pep     = ["10.0.0.16/29"]
      }
    }
    "databricks" = {
      vnet_address_space = ["10.1.0.0/16"]
      snets = {
        private = ["10.1.0.0/26"]
        public  = ["10.1.0.64/26"]
        pep     = ["10.1.0.128/29"]
      }
    }
    "prod" = {
      vnet_address_space = ["10.2.0.0/16"]
      snets = {
        vm           = ["10.2.0.0/25"]
        frontend_pep = ["10.2.0.128/29"]
      }
    }
  }

  // re-organize subnets to a map
  subnets = { for item in flatten([for key, value in local.vnets : [
    for snet_key, snet_value in value.snets : {
      full_key         = "${key}-${snet_key}"
      snet_key         = "${key}-${snet_key}"
      address_prefixes = snet_value
      vnet_key         = key
      rg_key           = key
    }]
  ]) : item.full_key => item }

  # peerings on spoke vnet, only one peering can have
  #   use_remote_src_gateway = true
  peerings = {
    "prod-to-hub" = {
      src_vnet_key = "prod"
    }
    "databricks-to-hub" = {
      src_vnet_key = "databricks"
    }
  }
}
