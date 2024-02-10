resource "azurerm_public_ip" "lb_inbound" {
  name                = "pip-${local.name}"
  resource_group_name = azurerm_resource_group.demo.name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "lb_outbound" {
  name                = "pip-lb-demo-outbound-001"
  resource_group_name = azurerm_resource_group.demo.name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "demo" {
  name                = "lbe-${local.name}"
  location            = local.location
  resource_group_name = azurerm_resource_group.demo.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPInbound"
    public_ip_address_id = azurerm_public_ip.lb_inbound.id
  }

  frontend_ip_configuration {
    name                 = "PublicIPOutbound"
    public_ip_address_id = azurerm_public_ip.lb_outbound.id
  }
}

resource "azurerm_lb_backend_address_pool" "demo" {
  name            = "backendpool-001"
  loadbalancer_id = azurerm_lb.demo.id
}

# Add all IP configs on a NIC to this backend pool
resource "azurerm_lb_backend_address_pool_address" "demo" {
  count                   = length(azurerm_network_interface.demo["001"].ip_configuration)
  name                    = "address-${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.demo.id
  virtual_network_id      = azurerm_virtual_network.demo["001"].id
  ip_address              = azurerm_network_interface.demo["001"].ip_configuration[count.index].private_ip_address
}

# NOTE: In the Portal, you could set either a backend pool or a single VM as target
#       but this TF resource only supports setting a backend pool, and frontend port must be a range
resource "azurerm_lb_nat_rule" "vm" {
  name                = "SSH_Access"
  resource_group_name = azurerm_resource_group.demo.name
  loadbalancer_id     = azurerm_lb.demo.id
  protocol            = "Tcp"
  # frontend_port                  = 22
  frontend_port_start            = 22
  frontend_port_end              = 24
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPInbound"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.demo.id
}

resource "azurerm_lb_probe" "demo" {
  name            = "probe-port-80"
  loadbalancer_id = azurerm_lb.demo.id
  port            = 80
}

resource "azurerm_lb_rule" "demo" {
  name                           = "lb-rule-001"
  loadbalancer_id                = azurerm_lb.demo.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPInbound"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.demo.id]
  probe_id                       = azurerm_lb_probe.demo.id
  disable_outbound_snat          = true // NOTE: this is recommended, you need to create outbound rules explicitly
}

resource "azurerm_lb_outbound_rule" "demo" {
  name                     = "outbound-rule-001"
  loadbalancer_id          = azurerm_lb.demo.id
  protocol                 = "Tcp"
  backend_address_pool_id  = azurerm_lb_backend_address_pool.demo.id
  allocated_outbound_ports = 64

  frontend_ip_configuration {
    name = "PublicIPOutbound"
  }
}
