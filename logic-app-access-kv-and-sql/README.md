# Logic App accessing other resources

Test how logic app access other PaaS Services, which have public access disabled and private endpoints enabled

## Resources

- Logic app (consumption multi-tenant)
- Logic app (standard single-tenant)
- VNet for private endpoints
- Key vault with public network access disabled and a private endpoint
- SQL DB with private endpoint

Manually create:

- A workflow to access the secret `secret-001` in the key vault
  - Use the managed identity of the logic app


## Test access to KV secret

- Logic app (consumption multi-tenant)
  - KV - Allow public access from all networks: Success
  - KV - Allow public access from specific virtual networks and IP addresses: Failure
  - KV - Allow public access from specific virtual networks and IP addresses - Logic app connector outgoing IPs allowed: Success
  - KV - Disable publice access: Failure

  - *Allow trusted Microsoft services to bypass this firewall* doesn't work for logic apps

- Logic app (standard single-tenant) without vNet integration
  - KV - Allow public access from all networks: Success
  - KV - Disable publice access: Failure

- Logic app (standard single-tenant) with vNet integration, "Configuration routing - Content storage" must be enabled as well
  - KV - Disable publice access: Failure
