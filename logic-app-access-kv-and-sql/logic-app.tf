# the Logic app
resource "azurerm_logic_app_workflow" "example" {
  name                = "logic-demo-001"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  identity {
    type = "SystemAssigned"
  }

  workflow_parameters = {
    # "$connections" = jsonencode(
    #   {
    #     defaultValue = {}
    #     type         = "Object"
    #   }
    # )
  }

  parameters = {
    # "$connections" = jsonencode(
    #   {
    #     azureblob = {
    #       connectionId   = azurerm_api_connection.example.id
    #       connectionName = local.connection_name
    #       id             = data.azurerm_managed_api.example.id
    #     }
    #   }
    # )
  }

  lifecycle {
    # NOTE: ignore changes
    ignore_changes = [parameters, workflow_parameters]
  }
}

# # an API connection to a storage account
# resource "azurerm_api_connection" "example" {
#   name                = local.connection_name
#   resource_group_name = azurerm_resource_group.demo.name
#   managed_api_id      = data.azurerm_managed_api.example.id
#   display_name        = "Blob Connection 001"

#   parameter_values = {
#     accountName = local.storage_account_name
#     accessKey   = azurerm_storage_account.example.primary_access_key
#   }

#   lifecycle {
#     # NOTE: since the connectionString is a secure value it's not returned from the API
#     ignore_changes = [parameter_values]
#   }
# }
