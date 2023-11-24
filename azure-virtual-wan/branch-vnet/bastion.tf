# Azure Bastion
# Public IPs
resource "azurerm_public_ip" "demo" {
  name                = "pip-bastion-${local.name}-001"
  location            = var.region
  resource_group_name = azurerm_resource_group.demo.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Azure Bastion
resource "azurerm_bastion_host" "demo" {
  name                = "bas-${local.name}-001"
  location            = var.region
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                 = "bas-ipconfig-001"
    public_ip_address_id = azurerm_public_ip.demo.id
    subnet_id            = azurerm_subnet.all["AzureBastionSubnet"].id
  }
}
