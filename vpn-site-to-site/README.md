# VPN site-to-site connection

Adapted from https://github.com/Azure/terraform/blob/master/quickstart/301-hub-onprem, which has two onprems, an NVA in hub, a on-prem vNet

Similar to the [vpn-vnet-to-vnet](../vpn-vnet-to-vnet/) demo

![Resources](./vpn-site-to-site-connection.drawio.svg)

- Two vNets
  - On-prem is simulated using a vnet
- One VPN gateway on each side
- One local network gateway on each side
- One public IP for each VPN gateway
- "site-to-site" type connection

## Testing

```sh
# login to onprem VM
ssh -i ~/downloads/azure-test adminuser@<onprem-vm-public-ip>

# test connection to hub-vm
ping 10.0.1.4
```