variable "name" {
  type = string
}

variable "location" {
  type    = string
  default = "Australia East"
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "private_service_connection" {
  type = any
}

variable "private_dns_zone_id" {
  type    = string
  default = ""
}
