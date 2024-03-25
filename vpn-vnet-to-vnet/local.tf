locals {
  vm_size = "Standard_B1s"
  vm_image = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "22.04.202403080"
  }
}
