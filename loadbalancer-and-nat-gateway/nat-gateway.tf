resource "azurerm_public_ip" "nat_gateway" {
  name                = "pip-nat-gateway-000"
  resource_group_name = azurerm_resource_group.demo.name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"] # IP needs to be in the same zone as NAT gateway
}

# NAT gateway is zonal, not zone redundant
resource "azurerm_nat_gateway" "demo" {
  name                    = "ng-000"
  resource_group_name     = azurerm_resource_group.demo.name
  location                = local.location
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "demo" {
  nat_gateway_id       = azurerm_nat_gateway.demo.id
  public_ip_address_id = azurerm_public_ip.nat_gateway.id
}

resource "azurerm_subnet_nat_gateway_association" "demo" {
  for_each       = { for k, v in local.snets : k => v if v.nat_gateway == true }
  subnet_id      = azapi_resource.subnet[each.key].id
  nat_gateway_id = azurerm_nat_gateway.demo.id
}
