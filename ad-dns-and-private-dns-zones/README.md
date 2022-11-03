# Integration between Azure private DNS zones and AD integrated DNS

![Overview](./azure_dns-resolution.drawio.svg)

See the diagram above, DC integrated DNS has a quirk behavior, if it has a forward lookup zone for any `CNAME` zone in response from upstream resolvers, it overwrites the response with records in the forward lookup zone.

1. `vm-test`: `tfdemogary001.blob.core.windows.net` resolves to a public IP

    ```powershell
    nslookup tfdemogary001.blob.core.windows.net

    # Server:  UnKnown
    # Address:  10.0.0.4

    # Non-authoritative answer:
    # Name:    blob.dm2prdstr04a.store.core.windows.net
    # Address:  20.150.95.196
    # Aliases:  tfdemogary001.blob.core.windows.net
    #           tfdemogary001.privatelink.blob.core.windows.net
    ```

1. `vm-dns`: Add conditional forwarder zone

    ```powershell
    Add-DnsServerConditionalForwarderZone -ComputerName vm-dns `
      -Name blob.core.windows.net `
      -MasterServers 168.63.129.16
    ```

1. `vm-test`: `tfdemogary001.blob.core.windows.net` resolves to a private IP

    ```powershell
    nslookup tfdemogary001.blob.core.windows.net
    # Server:  UnKnown
    # Address:  10.0.0.4

    # Non-authoritative answer:
    # Name:    tfdemogary001.privatelink.blob.core.windows.net
    # Address:  10.1.0.5
    # Aliases:  tfdemogary001.blob.core.windows.net
    ```

1. `vm-dns`: Add a forward lookup zone and a record `tfdemogary001`, pointing to a dummy IP

    - Manually add forward lookup zone `privatelink.blob.core.windows.net`
    - Add an "A" record `tfdemogary001`, pointing to `22.22.22.22`

1. `vm-test`: The record in forward lookup zone overwrites the IP from private DNS zone

      ```powershell
      nslookup tfdemogary001.blob.core.windows.net
      Server:  UnKnown
      Address:  10.0.0.4

      Non-authoritative answer:
      Name:    tfdemogary001.privatelink.blob.core.windows.net
      Address:  22.22.22.22
      Aliases:  tfdemogary001.blob.core.windows.net
      ```

1. `vm-dns`: Delete `tfdemogary001` from forward lookup zone `privatelink.blob.core.windows.net`

1. `vm-test`: Now an empty response

      ```powershell
      nslookup tfdemogary001.blob.core.windows.net
      Server:  UnKnown
      Address:  10.0.0.4

      Non-authoritative answer:
      Name:    tfdemogary001.blob.core.windows.net
      ```