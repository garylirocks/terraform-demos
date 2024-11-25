# Azure Virtual Network Manager

![Architecture](./design.drawio.svg)

Pre Terraform:

- Generate SSH keys: `ssh-keygen -t rsa -f ./azure-test.localonly`

Terraform creates:

- One hub and three spoke vNets
  - One VM per vNet
  - Hub VM serves as an NVA
- Azure Virtual Network Manager

Post Terraform:

- "Routing" is not supported by azurerm provider yet, you need to:
  - Enable "Routing" feature in the Portal manually
  - Add "Routing" configurations and deployment
  - Run `sudo sysctl -w net.ipv4.ip_forward=1` on the hub VM to enable IP forwarding


## Testing

### Connectivity

- When both "Hub-and-spoke" and "Mesh" topology configurations are deployed, "Hub-and-spoke" takes precedence, creating visible peerings in the Portal
- "Mesh" adds route of `ConnectedGroup` type to effective routes, but NO visible peerings in the Portal
- Test connectivity:
  ```sh
  ssh -i ./azure-test.localonly adminuser@<hub-vm-ip>

  # vm in spokes
  ping 10.1.0.4
  ping 10.16.0.4
  ping 10.17.0.4
  ```

### Routing

- Can connect to `work-001` from `vm-admin` via `vm-hub`

  ```sh
  nc -zvw3 10.16.0.4 22
  ```

- On hub VM, check the traffic

  ```sh
  sudo tcpdump -nn host 10.16.0.4
  ```

### Security Admin

- `work-01` has an NSG rule blocking TCP/22
- An "AlwaysAllow" security admin rule overwrites it