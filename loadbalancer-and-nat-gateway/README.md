# README

This demo is to test:

- Azure Load Balancer rules
- VM outbound connection methods priority

Resources:

![Diagram](./load-balancer-and-nat-gateway.drawio.svg)

- A vNet
  - Three subnets,
    - Implicit outbound connectivity disabled by setting `defaultOutboundAccess = false` on subnets
    - Two connected to a NAT gateway
    - Same NSG associated to all subnets (allow ports 22 and 80)
  - One VM in each subnet
  - NIC on each VM has two private IPs
  - Each VM has two outbound connection methods
- One Standard load balancer
  - Two public frontend IPs, one for inbound, one for outbound
  - A backend pool, contains two VMs
  - A load balancing rule (port 80)
  - An inbound NAT rule (port 22, for SSH login)
  - An outbound rule


## Testing

1. SSH login to VMs

    ```sh
    # vm-000, use LB inbound NAT rule
    ssh -i ~/downloads/azure-test -p port adminuser@<lb-inbound-ip>

    # vm-001, use LB inbound NAT rule, port is different
    ssh -i ~/downloads/azure-test -p port adminuser@<lb-inbound-ip>

    # vm-002
    ssh -i ~/downloads/azure-test adminuser@<vm-002-nic-ip>
    ```

2. Test outbound connection method

    ```sh
    # use this to test your connectivity to the Internet and get your IP info
    curl --max-time 3 ipinfo.io
    ```

    All should be successful, note which IP is showing up

3. To test load balancing rule

    1. `sudo apt install nginx`
    2. Wait a little while, so the backend instance becomes healthy
    3. Run this on localhost: `bash test-load-balancing-rule.sh`