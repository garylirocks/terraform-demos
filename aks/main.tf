locals {
  location = "Australia East"
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-aks-demo-001"
  location = local.location
}

resource "azurerm_kubernetes_cluster" "demo" {
  name                = "aks-demo-001"
  location            = local.location
  resource_group_name = azurerm_resource_group.demo.name
  dns_prefix          = "aks-demo-001"
  sku_tier            = "Free"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}
