# Azure Virtual WAN Demo Environment

## Overview
This is a Terraform based demonstration of Azure Virtual WAN. The environment is designed to provide a simple foundation that you can add additional services (Gateways, Firewalls, etc.) into, allowing the demonstration of concepts and technologies. This lab has two options - with or without Azure Firewall, and is based on a two-region design.

## What does this Lab deploy?

### Without Azure Firewall:

![Virtual WAN Demo Lab](https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/Virtual-WAN-Demo/images/Virtual-WAN.png?raw=true)

### With Azure Firewall:

![Virtual WAN Demo Lab - with Azure Firewall](https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/Virtual-WAN-Demo/images/Virtual-WAN-with-Firewall.png?raw=true)

### What does this Lab Deploy?

This lab deploys the following Resources:

1. A Resource Group in two Azure Regions (based on variables)
1. A Virtual WAN in the Primary Region
1. A Virtual WAN Hub in two Azure Regions
1. A vNet in each Azure Region which is connected to the Virtual WAN Hub.
1. A Subnet and NSG in each of the above vNets.
1. A Subnet in each Region to be used for Azure Bastion.
1. Azure Bastion in each Region to allow for access to the VMs for Testing.
1. A Virtual Machine in each Azure Region (in the Regional vNets), to allow testing of Connectivity.
1. (Optional) Firewall and firewall policy
  - Routing intent - next hop set to the Firewall
1. (Optional) A mock branch (vnet) to demo site-to-site VPN connection to vHub
  - VPN gateway
  - Bastion
  - Workload VM
  - vWAN VPN site
  - vHub VPN gateway
1. (Optional) Log analytics workspace
   1. Diagnostic settings for vWan site-to-site VPN
   1. Diagnostic settings for vHub ?


## Notes

- Seems there is no setting to create a VPN gateway in a vHub, need to do this manually
- Azure Firewall policy and Azure Firewall need to be of the same SKU


## Testing

- Connectivity

  - With firewall deployed
  - Login to AUE VM, you should be able to run `ping 10.2.1.4` successfully
  - After you change the firewall rule to "Deny", `ping` will fail
