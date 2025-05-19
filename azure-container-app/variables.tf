variable "subscription_id" {
  type = string
}

variable "datadog_api_key" {
  type      = string
  sensitive = true
}
