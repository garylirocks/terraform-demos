# README

Create a testing resource group to try out various Azure services, features

  - a vnet
  - a simple Linux VM
  - a private DNS zone, linked to the vnet, auto-registration enabled
  - a storage account
  - a log analytics workspace
  - Log analytics agent VM extension connected to the workspace



To find available VM images:

```sh
az vm image list --location australiaeast -otable
```
