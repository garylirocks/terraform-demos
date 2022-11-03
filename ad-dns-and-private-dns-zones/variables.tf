variable "location" {
  description = "Location to deploy resources"
  type        = string
  default     = "centralus"
}

variable "username" {
  description = "Username for Virtual Machines"
  type        = string
  default     = "AzureAdmin"
}

variable "password_file_path" {
  description = "Password must meet Azure complexity requirements"
  type        = string
  default     = "./password.localonly.txt"
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_B2s"
}
