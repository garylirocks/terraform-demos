# VPN vNet-to-vNet connection

Adapted from https://github.com/Azure/terraform/blob/master/quickstart/301-hub-spoke, which has two spokes, an NVA in hub, a on-prem vNet

![Resources](./vpn-vnet-to-vnet-connection.drawio.svg)

- Two vNets
- One VPN gateway in each vNet
- One public IP for each VPN gateway
- "VNet-to-VNet" type connection (does not need local network gateway resources)


## Testing

```sh
# login to spoke VM
ssh -i ~/downloads/azure-test adminuser@<spoke-vm-public-ip>

# test connection to hub-vm
ping 10.0.1.4
```