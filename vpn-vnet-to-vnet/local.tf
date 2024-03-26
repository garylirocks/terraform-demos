locals {
  vm_size = "Standard_B1s"
  vm_image = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "22.04.202403080"
  }

  vm_admin_username = "adminuser"

  vnets = {
    hub = {
      prefix         = "hub"
      location       = "australiaeast"
      resource-group = "rg-hub-vnet"
      shared-key     = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
      address-space  = ["10.0.0.0/16"]
    }

    spoke = {
      prefix         = "spoke"
      location       = "australiasoutheast"
      resource-group = "rg-spoke-vnet"
      address-space  = ["192.168.0.0/16"]
    }
  }
}
