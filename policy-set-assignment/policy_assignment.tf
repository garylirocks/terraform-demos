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
