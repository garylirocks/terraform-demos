# Azure Bastion
# Public IPs
resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion-001"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"
  allocation_method   = "Static"
}

# Azure Bastion
resource "azurerm_bastion_host" "this" {
  name                = "bas-001"
  location            = var.location
  resource_group_name = var.rg_name

  sku         = "Standard"
  scale_units = 2 // NOTE: 2 is the minimum

  copy_paste_enabled     = true
  file_copy_enabled      = true
  ip_connect_enabled     = true
  tunneling_enabled      = true
  shareable_link_enabled = true

  ip_configuration {
    name                 = "bas-ipconfig-001"
    public_ip_address_id = azurerm_public_ip.bastion.id
    subnet_id            = var.subnet_id
  }
}
