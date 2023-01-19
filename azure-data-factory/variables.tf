variable "env" {
  type        = string
  description = "environment, dev or prod"
  default     = "dev"
}

variable "vsts_configuration" {
  type        = map(any)
  description = "Git config"
  default     = null
}
