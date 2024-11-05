# DNS Private Resolver

![Architecture](./design.drawio.svg)

Create:

- Hub and spoke vNets
  - Spoke vNet uses inbound endpoint as DNS server
- One Linux VM in each vNet
- Private DNS zone linked to hub vNet
- DNS Private Resolver in hub vNet
- On-prem vNet
  - Has a Windows domain controller, with DNS feature installed by script
  - Peered to hub vNet (in real world, it would be a VPN/ExpressRoute)


## Testing

VM in hub/spoke vNets should be able to resolve both `test.on-prem.example.com` and `test.azure.example.com`

```sh
ssh -i ~/downloads/azure-test adminuser@vm-ip

nslookup test.azure.example.com

# Server:         127.0.0.53
# Address:        127.0.0.53#53

# Non-authoritative answer:
# Name:   test.azure.example.com
# Address: 1.1.1.1

nslookup test.on-prem.example.com
# Server:         127.0.0.53
# Address:        127.0.0.53#53

# Non-authoritative answer:
# Name:   test.on-prem.example.com
# Address: 2.2.2.2
```

Windows domain controller

- RDP to it
- Add a Forward Lookup Zone: `on-prem.example.com`, and a record set: `test A 2.2.2.2`
- Add a Conditional Forward Zone: `azure.example.com -> 10.0.30.4`
- It should be able to resolve both `test.on-prem.example.com` and `test.azure.example.com`

  ```sh
  nslookup test.on-prem.example.com
  # Server:  UnKnown
  # Address:  192.168.0.4

  # Name:    test.on-prem.example.com
  # Address:  2.2.2.2

  nslookup test.azure.example.com
  # Server:  UnKnown
  # Address:  192.168.0.4

  # Non-authoritative answer:
  # Name:    test.azure.example.com
  # Address:  1.1.1.1
  ```