resource "azurerm_policy_set_definition" "example" {
  name                = "garyTestPolicySet-${filemd5("./gary_test_policyset.params.json")}"
  policy_type         = "Custom"
  display_name        = "Gary Test Policy Set"
  management_group_id = azurerm_management_group.level1.id

  parameters = file("./gary_test_policyset.params.json")

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.policy.id
    reference_id         = "test-policy"
    parameter_values     = <<VALUE
    {
      "allowedLocations": {"value": "[parameters('allowedLocations_set')]"}
    }
VALUE
  }
}

# a builtin policy
data "azurerm_policy_definition" "add_tag_subscription" {
  display_name = "Add a tag to subscriptions"
}

data "azurerm_policy_definition" "require_tag_resource" {
  display_name = "Require a tag on resources"
}

resource "azurerm_policy_set_definition" "tagging" {
  name                = "garyTestPolicySet_tagging"
  policy_type         = "Custom"
  display_name        = "Gary Test Policy Set for tagging"
  management_group_id = azurerm_management_group.level1.id

  parameters = <<PARAMETERS
    {
      "tagName_set": {
          "type": "String",
          "metadata": {
              "description": "Name of the tag, such as 'environment'",
              "displayName": "Tag Name"
          }
      },
      "tagValue_set": {
          "type": "String",
          "metadata": {
              "description": "Value of the tag, such as 'test'",
              "displayName": "Tag Value"
          }
      }
    }
PARAMETERS

  #   policy_definition_reference {
  #     policy_definition_id = data.azurerm_policy_definition.add_tag_subscription.id
  #     parameter_values     = <<VALUE
  #     {
  #       "tagName": {"value": "[parameters('tagName_set')]"},
  #       "tagValue": {"value": "[parameters('tagValue_set')]"}
  #     }
  # VALUE
  #   }

  policy_definition_reference {
    policy_definition_id = data.azurerm_policy_definition.require_tag_resource.id
    reference_id         = "require_tag_resource"
    parameter_values     = <<VALUE
    {
      "tagName": {"value": "[parameters('tagName_set')]"}
    }
VALUE
  }
}
