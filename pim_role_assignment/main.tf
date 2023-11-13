data "azurerm_subscription" "primary" {}

data "azurerm_client_config" "example" {}

data "azurerm_role_definition" "example" {
  name = "Reader"
}

resource "time_static" "example" {}

resource "azurerm_pim_eligible_role_assignment" "example" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = "${data.azurerm_subscription.primary.id}${data.azurerm_role_definition.example.id}"
  principal_id       = data.azurerm_client_config.example.object_id

  schedule {
    start_date_time = time_static.example.rfc3339
    expiration {
      duration_hours = 8
    }
  }

  justification = "Expiration Duration Set"

  ticket {
    number = "1"
    system = "example ticket system"
  }
}
