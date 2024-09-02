data "azurerm_client_config" "current" {}

resource "random_pet" "name" {
}

resource "azurerm_resource_group" "example" {
  name     = "rg-app-${local.name}-001"
  location = local.region

  tags = {
    BusinessService   = "Cloud Capabilities"
    SupportTeam       = "ACC-Platforms-CloudOps"
    PrimaryContact    = "Product Owner Cloud Capabilities"
    TechnicalContact  = "Product Owner Cloud Capabilities"
    BusinessContact   = "RTE TSP"
    BillingIdentifier = "409"
    ProjectIdentifier = "000"
    Availability      = "07:00 - 19:00"
    PolicyExclusion   = "AKSManagedResource"
  }
}


module "workload-vnet" {
  resource_group_name = azurerm_resource_group.example.name
  vnet_name           = "vnet-${local.name}-001"
  address_space       = ["10.0.0.0/24"]
  location            = local.region
}

module "workload-subnet" {
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = module.workload-vnet.vnet_name

  # Here one can define subnets to be added to the vnet. Each "subnet_names" entry should match the "subnet_prefixes" entry. 1 entry per subnet
  subnet_names    = ["snet-workload", "snet-agw"]
  subnet_prefixes = ["10.0.0.0/26", "10.0.0.64/26"]

  nsg_ids                                              = {}
  subnet_service_endpoints                             = {}
  route_tables_ids                                     = {}
  subnet_private_endpoint_network_policies_enabled     = {}
  subnet_private_link_service_network_policies_enabled = {}
  subnet_delegation                                    = {}
}
