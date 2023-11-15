# Logic App accessing other resources

Test how logic app access other PaaS Services, which have public access disabled and private endpoints enabled

## Resources

- Logic app
- VNet for private endpoints
- Key vault with public network access disabled and a private endpoint
- SQL DB with private endpoint

Manually create:

- A workflow to access the secret `secret-001` in the key vault
  - Use the managed identity of the logic app


## Tests

- Logic app workflow access to KV secret
  - KV - Allow public access from all networks: Success
  - KV - Allow public access from specific virtual networks and IP addresses: Failure
  - KV - Allow public access from specific virtual networks and IP addresses - Logic app connector outgoing IPs allowed: Success

  - *Allow trusted Microsoft services to bypass this firewall* doesn't work for logic apps
