# Azure Bastion
# Public IPs
resource "azurerm_public_ip" "all" {
  for_each            = local.regions
  name                = "pip-bastion-${each.key}-001"
  location            = azurerm_resource_group.all[each.key].location
  resource_group_name = azurerm_resource_group.all[each.key].name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    environment = local.environment_tag
  }
}

# Azure Bastion
resource "azurerm_bastion_host" "all" {
  for_each            = local.regions
  name                = "bas-${each.key}-001"
  location            = azurerm_resource_group.all[each.key].location
  resource_group_name = azurerm_resource_group.all[each.key].name

  ip_configuration {
    name                 = "bas-ipconfig-001"
    public_ip_address_id = azurerm_public_ip.all[each.key].id
    subnet_id            = azurerm_subnet.bastion[each.key].id
  }
}
