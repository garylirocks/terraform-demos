variable "create_firewall" {
  description = "Should a firewall be created in each vHub"
  type        = bool
}

variable "create_vpn_site" {
  description = "Should a vNet for a VPN site be created"
  type        = bool
}

variable "create_monitoring" {
  description = "Should monitoring be created"
  type        = bool
}
