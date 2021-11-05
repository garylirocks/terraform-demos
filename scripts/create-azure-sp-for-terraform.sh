#!/bin/bash

set -euo pipefail

SP_NAME=$1

# get default subscription id
ARM_SUBSCRIPTION_ID=$(az account list \
  --query "[?isDefault][id]" \
  --all \
  --output tsv)

# create a sp and get the secret
# - `Contributor` is the default role for a service principal, which has full permissions to read and write to an Azure subscription
# - get the service principal id
ARM_CLIENT_ID=$(az ad sp create-for-rbac \
  --name $SP_NAME \
  --role Contributor \
  --scopes "/subscriptions/$ARM_SUBSCRIPTION_ID" \
  --query appId \
  --output tsv)

# password was generated in the last step, which we used to get the appId
# so we reset the password and get it here
ARM_CLIENT_SECRET=$(az ad sp credential reset \
  --name $SP_NAME \
  --query password \
  --output tsv)

# get tenant id
ARM_TENANT_ID=$(az ad sp show \
  --id $ARM_CLIENT_ID \
  --query appOwnerTenantId \
  --output tsv)

echo "DONE"
echo "ARM_TENANT_ID=${ARM_TENANT_ID}"
echo "ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}"
echo "ARM_CLIENT_ID=${ARM_CLIENT_ID}"
echo "ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}"
