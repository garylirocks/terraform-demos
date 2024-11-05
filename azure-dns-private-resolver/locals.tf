locals {
  instances = {
    "hub" = {
      vnet_address_space          = ["10.0.0.0/16"]
      snet_vm_address_space       = ["10.0.1.0/24"]
      snet_inbound_address_space  = ["10.0.30.0/24"]
      inbound_endpoint_ip         = "10.0.30.4"
      snet_outbound_address_space = ["10.0.31.0/24"]
      a_record_ip                 = "1.1.1.1"
      dns_server_ips              = [] # Azure-provided DNS
    }

    "spoke" = {
      vnet_address_space    = ["10.1.0.0/16"]
      snet_vm_address_space = ["10.1.1.0/24"]
      dns_server_ips        = ["10.0.30.4"] # the inbound endpoint
    }


    "on-prem" = {
      vnet_address_space    = ["192.168.0.0/16"]
      snet_vm_address_space = ["192.168.0.0/24"]
      dns_server_ips        = ["192.168.0.4"] # the DC VM
    }
  }
}
