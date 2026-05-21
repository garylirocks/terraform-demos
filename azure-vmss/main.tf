terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "4.66.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "admin_password" {
  description = "Admin password for the VMSS instances"
  type        = string
  sensitive   = true
}

resource "azurerm_resource_group" "main" {
  name     = "rg-vmss-01"
  location = "australiaeast"
}

resource "azurerm_linux_virtual_machine_scale_set" "res-0" {
  admin_password                                    = var.admin_password
  admin_username                                    = "localroot"
  computer_name_prefix                              = "vmss-gary"
  disable_password_authentication                   = false
  do_not_run_extensions_on_overprovisioned_machines = false
  encryption_at_host_enabled                        = false
  extension_operations_enabled                      = true
  extensions_time_budget                            = "PT1H30M"
  instances                                         = 1
  location                                          = "australiaeast"
  max_bid_price                                     = -1
  name                                              = "vmss-gary-test-001"
  overprovision                                     = false
  platform_fault_domain_count                       = 1
  priority                                          = "Regular"
  provision_vm_agent                                = true
  resilient_vm_creation_enabled                     = false
  resilient_vm_deletion_enabled                     = false
  resource_group_name                               = azurerm_resource_group.main.name
  secure_boot_enabled                               = false
  single_placement_group                            = false
  sku                                               = "Standard_D2ds_v5"
  tags                                              = {}
  upgrade_mode                                      = "Manual"
  vtpm_enabled                                      = false
  zone_balance                                      = false
  zones                                             = []
  boot_diagnostics {
    storage_account_uri = ""
  }
  network_interface {
    dns_servers                   = []
    enable_accelerated_networking = true
    enable_ip_forwarding          = false
    name                          = "vnet-australiaeast-nic01"
    network_security_group_id     = azurerm_network_security_group.main.id
    primary                       = true
    ip_configuration {
      application_gateway_backend_address_pool_ids = []
      application_security_group_ids               = []
      load_balancer_backend_address_pool_ids       = []
      load_balancer_inbound_nat_rules_ids          = []
      name                                         = "vnet-australiaeast-nic01-defaultIpConfiguration"
      primary                                      = true
      subnet_id                                    = azurerm_subnet.main.id
      version                                      = "IPv4"
    }
  }
  os_disk {
    caching                   = "ReadOnly"
    disk_size_gb              = 75
    storage_account_type      = "Standard_LRS"
    write_accelerator_enabled = false

    diff_disk_settings {
      option    = "Local"
      placement = "ResourceDisk" // Standard_D2ds_v6 requires 'NvmeDisk' here, not supported by this proveider yet
    }

  }
  # plan {
  #   name      = "20_04-lts"
  #   product   = "0001-com-ubuntu-server-focal"
  #   publisher = "canonical"
  # }
  scale_in {
    force_deletion_enabled = false
    rule                   = "Default"
  }
  source_image_reference {
    offer     = "ubuntu-24_04-lts"
    publisher = "canonical"
    sku       = "server"
    version   = "latest"
  }
}
