# Private endpoint

This demo showcases:

1. Using a custom module from the `/modules` folder
2. Define and use alias providers, the private DNS zone is in a different subscription
3. Use `terraform_remote_state` data provider

Usage:

1. Use `base-resources` to stand up:
    1. With default provider, create a resource group, vnet, subnet, key vault
    2. With alias provider `azurerm.dns`, which points to another subscription, create a resource group and a private DNS zone
2. Go to `private-endpoint`,
    1. it uses `terraform_remote_state` to reference resources from the `base-resources` folder
    1. it creates two private endpoints, one with associated DNS record, one without

Note:

1. `base-resources` and `private-endpoint` don't need to be separate, we stand up base resources first so it's faster to test the private endpoint module