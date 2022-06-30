resource "azurerm_management_group_policy_assignment" "example" {
  name                 = "gary_test_assignment"
  policy_definition_id = azurerm_policy_set_definition.example.id
  management_group_id  = azurerm_management_group.level1.id

  parameters = <<VALUE
    {
      "allowedLocationsForSet": {"value": ["australiaeast"]}
    }
VALUE
}

resource "azurerm_management_group_policy_assignment" "tagging" {
  name                 = "gary_assignment_tagging"
  display_name         = "Gary Assignment Tagging"
  policy_definition_id = azurerm_policy_set_definition.tagging.id
  management_group_id  = azurerm_management_group.level1.id

  // required for a "modify" policy
  identity {
    type = "SystemAssigned"
  }
  location = "australiaeast"

  parameters = <<VALUE
    {
      "tagName_set": {"value": "env"},
      "tagValue_set": {"value": "testing"}
    }
VALUE
}
