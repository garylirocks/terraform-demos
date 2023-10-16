# README

Testing what permissions a service principal requires to read a secrets in a keyvault.

Resources:
  - A KV with RBAC permission model
    - with a secret
  - A KV with Access Policy permission model
    - with a secret
  - An app reg, with a password, and a service principal

To create a secret in the new key vaults, the current user (not the new service principal) needs data plane permissions as well:
  - KV with RBAC permission model
    - "Key Vault Secrets Officer" role
  - KV with Access Policy permission model
    - "Get, List, Set, Delete" on secrets

## To test

1. `tf apply` at the top level
1. Log out, then log in as the service principal

    ```
    az logout

    app_id=$(tf output -raw app_id)
    password=$(tf output -raw app_password)
    tenant_id=$(tf output -raw tenant_id)

    # login with the service principal
    az login --service-principal \
      --tenant $tenant_id \
      --username $app_id \
      --password $password
    ```

1. Test reading secret with AZ CLI

    ```
    # only need "Key Vault Secrets User" on the secret, not the whole vault
    az keyvault secret show --name "top-secret" --vault-name "kv-rbac-temp-001"

    # only need "Get" on secrets
    az keyvault secret show --name "top-secret" --vault-name "kv-policy-temp-001"
    ```

1. Test reading secret with Terraform `data` block

    ```
    cd read-secret
    tf apply
    ```

## Conclusion

To allow a service principal to retrieve value of a secret from key vault:

- KV with RBAC permission model
  - "Key Vault Secrets User" role on the secret
  - "Key Vault Reader" role on the vault (only required by Terraform data block `azurerm_key_vault_secret`, not by AZ CLI)
- KV with Access Policy permission model
  - "Get" on secrets
  - "Key Vault Reader" role on the vault (only required by Terraform data block `azurerm_key_vault_secret`, not by AZ CLI)