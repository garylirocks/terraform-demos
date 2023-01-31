# Azure Data Factory

Create an ADF to test integration runtimes

Related resources for testing:

- Storage account: to test copying data
- Windows VM: to install integration runtime


## Manual steps

1. Go to ADF, add an self-hosted IR, download and install the IR software on the VM
2. Create linked services (to the blob storage) for testing


## Purpose

This could be used to test:

1. IR access to storage account
2. Which IR is used in a copy activity