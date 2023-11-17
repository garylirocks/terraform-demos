# Logic App Consumption (multi-tenant)

This demo is to create a simple logic app to test workflows, API connections, authentication to other services, etc.

It does not support vNet integration, private endpoints, etc. All the PaaS services are accessed via public endpoints.

Resources created

- Resource group
- Logic app (multi-tenant consumption plan)
- Storage account
  - with a container and blob for testing
- API connection to the storage account

## Manual steps

Workflow not created, you can create one to list blobs in `test-container/test-folder`

Note:

- API connections need secrets/tokens, if you update a connection in the Logic app designer, it would create a new API connection resource
- A bit hard to capture the workflow, better using ARM template ?
