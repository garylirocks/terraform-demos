Azure Verified Modules Terraform lab

See https://learn.microsoft.com/en-us/samples/azure-samples/avm-terraform-labs/avm-terraform-labs/

![Resource diagram](./azure-verified-module-lab.jpg)

- VM SSH private key saved as secret in Key Vault, when login using Bastion, it can be used directly, user has access to it
- Customer managed key for storage account saved as key in Key Vault, storage account managed identity has access to it
- Testing:
  - Login to VM via Bastion (private key from Key Vault)
  - Install Azure CLI
  - Login to Azure via managed identity of the VM
  - Upload/download files to the storage account
