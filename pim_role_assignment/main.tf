data "azurerm_subscription" "primary" {}


data "azurerm_role_definition" "example" {
  name = "Reader"
}

data "azuread_client_config" "current" {}

data "azuread_users" "members" {
  user_principal_names = ["chris@guisheng.li"]
}

resource "time_static" "example" {}

resource "azuread_group" "example" {
  display_name = "PIM-role-assignment"
  // current identity will be used as owner by default, if owners field is omitted
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  members          = data.azuread_users.members.object_ids
}


resource "azurerm_pim_eligible_role_assignment" "example" {
  scope              = data.azurerm_subscription.primary.id
  role_definition_id = "${data.azurerm_subscription.primary.id}${data.azurerm_role_definition.example.id}"
  principal_id       = azuread_group.example.object_id

  schedule {
    start_date_time = time_static.example.rfc3339
    expiration {
      duration_days = 180
    }
  }

  justification = "Allow the group to access the Azure resource"
}
