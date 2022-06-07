resource "azurerm_management_group" "level1" {
  display_name = "mg-test-level1"
}

resource "azurerm_management_group" "level2" {
  display_name               = "mg-test-level2"
  parent_management_group_id = azurerm_management_group.level1.id

  subscription_ids = [
    "70256be7-d155-4702-8976-0e7f9a046876"
  ]
}
