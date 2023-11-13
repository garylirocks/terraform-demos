# PIM role assignment

Try out PIM role assignments using Terraform

- `azurerm_pim_eligible_role_assignment`
- `azurerm_pim_active_role_assignment`

To use a service principal to assign PIM roles to other identities, the service principal needs:

- 'Microsoft.Resources/subscriptions/providers/read' over ARM scope (subscription, resource group, etc)
- Microsoft graph:
  - 'PrivilegedAccess.Read.AzureResources'
  - 'PrivilegedAccess.ReadWrite.AzureResources'