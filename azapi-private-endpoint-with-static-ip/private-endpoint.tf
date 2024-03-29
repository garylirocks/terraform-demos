resource "azapi_resource" "private_endpoint" {
  type      = "Microsoft.Network/privateEndpoints@2022-01-01"
  name      = "pe-vault-temp-001"
  location  = local.location
  parent_id = azurerm_resource_group.temp.id

  body = jsonencode({
    properties = {
      privateLinkServiceConnections = [
        {
          name = "gary-private-link"
          properties = {
            privateLinkServiceId = azurerm_key_vault.temp.id
            groupIds = [
              "vault"
            ]
            requestMessage = "Please approve my connection."
          }
        }
      ]
      subnet = {
        id = azurerm_subnet.endpoint.id
      }
      ipConfigurations = [
        {
          name = "garyStaticIpConfig"
          properties = {
            groupId          = "vault"
            memberName       = "default"
            privateIPAddress = "10.0.2.8"
          }
        }
      ]
      customNetworkInterfaceName = "nic-staticip"
    }
  })
}

/*
This does not work for Private DNS Zone Group
Seems an issue with Azure REST API

  az rest --method get --url "/subscriptions/<sub-id>/resourceGroups/rg-temp-001/providers/Microsoft.Network/privateEndpoints/pe-vault-temp-001/privateDnsZoneGroups/nonExistGroup?api-version=2022-01-01" --debug

This returns "200", while usually for a non exist resource, it should be "404"

Also see: https://github.com/pulumi/pulumi-azure-nextgen/issues/227
*/
# resource "azapi_resource" "private_dns_zone_group" {
#   type      = "Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-01-01"
#   name      = "default"
#   parent_id = azapi_resource.private_endpoint.id
#   body = jsonencode({
#     properties = {
#       privateDnsZoneConfigs = [
#         {
#           name = "privatelink_vaultcore_azure_net",
#           properties = {
#             privateDnsZoneId = azurerm_private_dns_zone.temp.id
#           }
#         }
#       ]
#     }
#   })
# }
