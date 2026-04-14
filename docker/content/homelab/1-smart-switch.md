---
title: 'Smart Switch'
draft: false
weight: 1
series: ["Homelab"]
series_order: 1
---

## Initial Configuration

Since I have a TP-Link smart switch I configured it using the program **Easy Smart Configuration Utility**. It can be downloaded [in this page](https://www.tp-link.com/us/support/download/tl-sg108e/v6/). The program will automatically find the smart switch as long as it is connected to the same firewall as the computer trying to access it. However, to update the firmware the smart switch must be connected to the computer within the same subnet. A direct connection is recommended, and the computer may be manually set with a static IP to be in the same subnet

## VLANs

I configured VLAN 254 for switch remote access through my firewall and physical access through ports 2 and 8. Ports 3-7 (the rest of the ports) are configured to be a trunk for internet access for the other VLANs that are used, while not allowing VLANs to communicate with each other.

Port 1 is a trunk for all VLANs used.

I also set the PVID settings to tag untagged traffic: port 2 and 8 are in VLAN 254, and the rest of the ports are in VLAN 2 since that is the VLAN for my Proxmox server that hosts my VMs.

| VLAN | VLAN Name  | Member Ports | Tagged Ports | Untagged Ports |
| ---- | ---------- | ------------ | ------------ | -------------- |
| 1    | agg        | 1            |              | 1              |
| 2    | host       | 1,3-7        | 1            | 3-7            |
| 3    | VM         | 1,3-7        | 1,3-7        |                |
| 4    | kubernetes | 1,3-7        | 1,3-7        |                |
| 5    | connector  | 1,3-7        | 1,3-7        |                |
| 254  | management | 1-2,8        | 1            | 2,8            |

PVID:

- Port 1 - VLAN 1
- Port 3-7 - VLAN 2
- Port 2,8 - VLAN 254

## Managing the smart switch after setup

These instructions will change after configuring remote access for the smart switch, but until then use these steps:

1. Connect a computer to port 2 of the smart switch
1. In the interface that is connected to the switch set the computer IP to 192.168.0.2 and subnet mask to 255.255.255.0. Leave the default gateway empty
1. In a browser go to the address [http://192.168.0.1/](http://192.168.0.1/).
