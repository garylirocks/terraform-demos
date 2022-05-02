# reference the state file in base-resources folder
data "terraform_remote_state" "base" {
  backend = "local"

  config = {
    path = "../base-resources/terraform.tfstate"
  }
}

# create a private endpoint with DNS record
module "private_endpoint" {
  source              = "../../modules/private_endpoint"
  name                = "pe-temp-001"
  location            = "Australia East"
  resource_group_name = data.terraform_remote_state.base.outputs.resource_group_name
  subnet_id           = data.terraform_remote_state.base.outputs.subnet_id

  private_service_connection = {
    name                           = "temp-privateserviceconnection"
    private_connection_resource_id = data.terraform_remote_state.base.outputs.keyvault_id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_id = data.terraform_remote_state.base.outputs.private_dns_zone_id
}

# create another private endpoint without DNS record
module "private_endpoint_2" {
  source              = "../../modules/private_endpoint"
  name                = "pe-temp-002"
  location            = "Australia East"
  resource_group_name = data.terraform_remote_state.base.outputs.resource_group_name
  subnet_id           = data.terraform_remote_state.base.outputs.subnet_id

  private_service_connection = {
    name                           = "temp-privateserviceconnection"
    private_connection_resource_id = data.terraform_remote_state.base.outputs.keyvault_id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}
