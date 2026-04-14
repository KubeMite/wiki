---
title: 'Smart Switch - Remote and Local Access'
draft: false
weight: 3
series: ["Homelab"]
series_order: 3
---

## Setup

I set the IP settings as a static IP for remote switch management over tailscale using my firewall, so do the following steps after the firewall is set up:

1. Connect a laptop to the management VLAN interface of the smart switch
1. From the **Easy Smart Configuration Utility** program -> IP Settings:
    1. DHCP Setting - Disable
    1. IP Address - 172.16.254.2
    1. Subnet Mask - 255.255.255.0
    1. Default Gateway - 172.16.254.1
    1. User Name - the switch user name
    1. Password - the switch password
    1. Press **Apply**
1. OPNSense GUI -> VPN -> Tailscale -> Settings -> Advertised Routes -> Press +
    1. Subnet - 172.16.254.2/32
    1. Description - Smart Switch
    1. Press **Save**
1. OPNSense GUI -> VPN -> Tailscale -> Settings -> Settings -> Press **Apply**
1. Tailscale GUI -> Machines -> The OPNSense machine -> Subnets -> Approve the subnet
1. In tailscale GUI update your **Access controls** to allow access to the advertised route from the required devices

## Access switch locally

1. Connect a laptop to the management VLAN interface of the smart switch
1. Change the laptop network settings:
    1. IP address - Any ip in the range 172.16.254.3-254
    1. Subnet mask - 255.255.255.0
    1. Default Gateway - 172.16.254.1
1. Access the switch management website by going to [http://172.16.254.2/](http://172.16.254.2/)

## Access switch remotely

From a device with tailscale installed and logged-in, in the browser go to the advertised route of the smart switch: [http://172.16.254.2/](http://172.16.254.2/)
