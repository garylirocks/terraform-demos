# PIM role assignment

Try out PIM role assignments using Terraform

- `azurerm_pim_eligible_role_assignment`
- `azurerm_pim_active_role_assignment`

To use a service principal to assign PIM roles for Azure resources, the service principal needs:

- 'User Access Administrator' over ARM scope (subscription, resource group, etc)
- 'Group.ReadWrite.All' to create and manage AAD groups
- 'User.Read.All' to read users

**Cannot manage role management policies (role settings) via Terraform**


## Run

A Terraform Cloud workspace is used as the backend, which has a dedicated service principal configured in environment.
