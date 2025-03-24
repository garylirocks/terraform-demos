module "bastion" {
  source = "./bastion"

  count = var.create_bastion ? 1 : 0

  subscription_id = var.subscription_id
  location        = azurerm_resource_group.hub.location
  rg_name         = azurerm_resource_group.hub.name
  subnet_id       = azurerm_subnet.bastion.id
}
