resource "azurerm_policy_definition" "policy" {
  name                = "gary_test_policy"
  policy_type         = "Custom"
  mode                = "Indexed"
  display_name        = "Gary test policy definition"
  management_group_id = azurerm_management_group.level1.id

  metadata = <<METADATA
    {
    "category": "General"
    }
METADATA

  policy_rule = <<POLICY_RULE
  {
    "if": {
      "not": {
        "field": "location",
        "in": "[parameters('allowedLocations')]"
      }
    },
    "then": {
      "effect": "deny"
    }
  }
POLICY_RULE

  parameters = <<PARAMETERS
  {
    "allowedLocations": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed locations for resources.",
        "displayName": "Allowed locations",
        "strongType": "location"
      }
    }
  }
PARAMETERS
}
