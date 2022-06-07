resource "azurerm_policy_set_definition" "example" {
  name                = "garyTestPolicySet"
  policy_type         = "Custom"
  display_name        = "Gary Test Policy Set"
  management_group_id = azurerm_management_group.level1.id

  parameters = <<PARAMETERS
    {
      "allowedLocationsForSet": {
          "type": "Array",
          "metadata": {
              "description": "The list of allowed locations for resources.",
              "displayName": "Allowed locations",
              "strongType": "location"
          }
      }
    }
PARAMETERS

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.policy.id
    parameter_values     = <<VALUE
    {
      "allowedLocations": {"value": "[parameters('allowedLocationsForSet')]"}
    }
VALUE
  }
}
