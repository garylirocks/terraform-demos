# VPN vNet-to-vNet connection

Adapted from https://github.com/Azure/terraform/blob/master/quickstart/301-hub-spoke, which has two spokes, an NVA in hub, a on-prem vNet

![Resources](./vpn-vnet-to-vnet-connection.drawio.svg)

- Two vNets
- One VPN gateway in each vNet
- One public IP for each VPN gateway