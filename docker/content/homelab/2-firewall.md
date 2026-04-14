---
title: 'Firewall'
draft: false
weight: 2
series: ["Homelab"]
series_order: 2
---

I installed OPNSense in a MiniPC ([BlackView MP80](https://www.blackview.hk/products/item/mp80) since it has two ethernet ports) as a firewall between my home router and my switch that is connected to my servers.

As a general guide I used the [official guide](https://docs.opnsense.org/manual/install.html#opnsense-installer), but detailed below are the steps I followed

## Installation

1. Download and verify the Proxmox ISO using [this guide](https://docs.opnsense.org/manual/install.html#download-and-verification)
2. Write the ISO to a usb using [rufus](https://rufus.ie/en/)
3. Connect the USB to the MiniPC
4. Start the MiniPC and press the delete button to enter BIOS
5. Go to the **Boot** tab and change **State After G3** to **Power on**. This ensures that the MiniPC will start up automatically after a power loss.
6. Go to the **Save & Exit** tab and under **Boot Override** choose the USB with the OPNSense install
7. An ACPI error hint will continually be printed to the terminal. I did not find a way to disable it, but it can be safely ignored
8. Once **Press any key to start the manual interface assignment:** appears press any key
    1. **Do you want to configure LAGGs now?** - N
    2. **Do you want to configure VLANS now?** - N
    3. **Enter the WAN interface name or 'a' for auto-detection:** Disconnect all ethernet cables connected to the MiniPC, then press **a**
    4. Connect an ethernet cable to the WAN port of the MiniPC, make sure that there is link and press **Enter**
    5. **Enter the LAN interface name or 'a' for auto-detection (or nothing if finished):** Disconnect all ethernet cables connected to the MiniPC, then press **a**
    6. Connect an ethernet cable to the LAN port of the MiniPC, make sure that there is link and press **Enter**
    7. **Enter the optional interface 1 name or 'a' for auto-detection (or nothing if finished):** Disconnect all ethernet cables connected to the MiniPC, then press **Enter**
    8. **Do you want to proceed?** - press **y**
9. When asked for **login:** enter installer
10. When asked for **Password:** enter **opnsense**
11. Keymap Selection - continue with default keymap
12. Choose one of the following tasks to perform - Install (ZFS)
13. Press OK with the default ZFS pool name
14. Select virtual device type - stripe
15. Select your disk and press **OK**
16. Last chance - Press **YES**
17. Continue with recommended swap (UFS) - Press **YES**
18. Enter and confirm your root password
19. Select **Complete install**, then select **Reboot now**

## Configure interface IPs

1. Change the IP of the interfaces in the console using the following sub-steps:
    1. Boot normally, then sign in as the root user
    1. Choose option **2**
    1. For LAN port:
        1. Enter the number of the LAN port
        1. **Configure IPv4 address LAN interface via DHCP?** - enter **N**
        1. **Enter the new LAN IPv4 address:** - enter **172.16.0.1**
        1. **Subnet mask** - enter 24
        1. **Enter upstream gateway address** - Press **Enter** since this is a LAN port and doesn't have a gateway
        1. **Configure IPv6 address LAN interface via WAN tracking?** - Enter **n**
        1. **Configure IPv6 address LAN interface via DHCP6?** - Enter **N**
        1. **Enter the new LAN IPv6 address:** - Press **Enter** since we don't want to use IPv6
        1. **Do you want to enable the DHCP server on LAN?** - Press **N** since we hand out IP addresses statically
        1. **Do you want to change the web GUI protocol from HTTPS to HTTP?** - Press **y** since all access across the network will be done locally or via an encrypted tunnel
        1. **Restore web GUI access defaults?** - Press **y** (it doesn't really matter since we didn't set anything up yet in the web GUI)
    1. Choose option **2**
    1. For WAN port:
        1. Enter the number of the WAN port
        1. **Configure IPv4 address WAN interface via DHCP?** - enter **N**
        1. **Enter the new WAN IPv4 address:** - enter **192.168.1.10**
        1. **Subnet mask** - enter 24
        1. **Enter upstream gateway address** - enter **192.168.1.1**
        1. **Do you want to use the gateway as the IPv4 name server, too?** - Enter **Y**
        1. **Configure IPv6 address WAN interface via DHCP6?** - Enter **N**
        1. **Enter the new WAN IPv6 address:** - Press **Enter** since we don't want to use IPv6
        1. **Restore web GUI access defaults?** - Press **y** (it doesn't really matter since we didn't set anything up yet in the web GUI)

## Initial Configuration

1. Connect the WAN interface on the firewall to the home network
1. Connect the LAN interface on the firewall directly to an interface on a computer, and in the computer set the IP address to 172.16.0.100 and subnet of /24. Then using a browser go to the address [http://172.16.0.1](http://172.16.0.1). You should see the OPNSense firewall login page
1. Log in with the root username and the password set earlier
1. Go through the initial wizard setup:
    1. Welcome - **Next**
    1. General Information:
        1. Hostname - OPNsense
        1. domain - internal
        1. Language - English
        1. Timezone - Etc/GMT+2
        1. DNS Server - 192.168.1.1
        1. Override DNS - Check
        1. DNS [Unbound] - Enable Resolver - Check
        1. Press **Next**
    1. Network (WAN):
        1. Type - Static
        1. MAC (spoofed) - Leave empty
        1. MTU - Leave empty
        1. MSS - Leave empty
        1. IP Address - 192.168.1.10/24
        1. Gateway - 192.168.1.1
        1. Default policies - Block RFC1918 Private Networks - Check
        1. Default policies - Block bogon networks - Check
        1. Press **Next**
    1. Network (LAN):
        1. Disable LAN - Uncheck
        1. IP Address - 172.16.0.1/24
        1. Configure DHCP server - Uncheck
        1. Press **Next**
    1. Set initial password:
        1. Root Password - Set root password
        1. Root Password Confirmation - Set root password
        1. Press **Next**
    1. Finish:
        1. Click **Apply**
1. OPNSense GUI -> System -> Firmware -> Settings -> Reboot - Check -> Save
1. OPNSense GUI -> System -> Firmware -> Status -> Check for updates -> Scroll down -> Update
1. The firewall will be rebooted automatically if needed
1. OPNSense GUI -> System -> Configuration -> Backups
    1. Backup Count -> 3 - Press **Save**
1. OPNSense GUI -> System -> Settings -> Administration:
    1. Login Messages - Uncheck
    1. Access log - Check
    1. Press **Save**
1. OPNSense GUI -> System -> Settings -> Cron -> Press the **+** button
    1. Enabled - Check
    1. Minutes - 0
    1. Hours - 10
    1. Day of the month - *
    1. Months - *
    1. Day of the week - 6
    1. Command - Automatic firmware update
    1. Parameters - Leave empty
    1. Description - Update every Saturday
    1. Press **Save** then **Apply**
1. OPNSense GUI -> System -> Settings -> Cron -> Press the **+** button
    1. Enabled - Check
    1. Minutes - 0
    1. Hours - 9
    1. Day of the month - *
    1. Months - *
    1. Day of the week - 6
    1. Command - Update and reload firewall aliases
    1. Parameters - Leave empty
    1. Description - Update aliases
    1. Press **Save** then **Apply**
1. OPNSense GUI -> System -> Settings -> Logging -> Local
    1. Enable local logging - Check
    1. Maximum preserved files - 10
    1. Maximum file size (MB) - 5
    1. Press **Apply**
1. OPNSense GUI -> System -> Settings -> Miscellaneous
    1. Cryptographic settings - Hardware acceleration - None (The N97 Intel CPU supports AES-NI which is enabled by default, thus there is no reason to select any other choice)
    1. Thermal Sensors - Hardware - Intel Core* CPU on-die thermal sensor (coretemp)
    1. Power Savings - Use PowerD - Check
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Diagnostics -> Aliases -> Press **Update bogons**

## Installing Plugins

1. OPNSense GUI -> System -> Firmware -> Plugins.
    1. Enable **Show community plugins**
    1. Download the following plugins:
        1. os-cpu-microcode-intel
        1. os-dmidecode
        1. os-netdata
        1. os-tailscale
        1. os-upnp
        1. os-frr
1. Then reboot to make sure any changes done by the plugins will take effect

## Setting up tailscale

These steps have been taken from [this guide](https://tailscale.com/kb/1097/install-opnsense)

1. Get a tailscale auth key in order to add the firewall to the network non-interactively
    1. Go to the tailscale console -> settings -> keys
    1. Press **Generate auth key**
        1. Description - OPNSense
        1. Reusable - Uncheck
        1. Expiration - 1 day
        1. Ephemeral - Uncheck
        1. Pre-approved - Check
        1. Tags - Uncheck
        1. Press **Generate key**
    1. Generate the key and copy it
1. OPNSense GUI -> VPN -> Tailscale -> Authentication
    1. Login Server - [https://controlplane.tailscale.com](https://controlplane.tailscale.com)
    1. Pre-authentication Key - Paste the key you generated from the tailscale console
    1. Press Apply
1. OPNSense GUI -> VPN -> Tailscale -> Settings
    1. Enabled - Check
    1. Accept DNS - Check
    1. Advertise Exit Node - Uncheck
    1. Use Exit Node - None
    1. Accept Subnet Routes - Uncheck
    1. Press **Apply**
1. Tailscale GUI -> the three dots next to opnsense server -> Press **Disable key expiry**
1. OPNSense GUI -> Interfaces -> Assignments - Assign a new interface
    1. Device - tailscale0
    1. Description - tailscale
    1. Press **Add**
    1. Press **Save**
1. OPNSense GUI -> Interfaces -> tailscale
    1. Enable - Check
    1. Lock - Check
    1. Press **Save**
    1. Press **Apply changes** in the button that appears at the top of the page
1. OPNSense GUI -> Services -> UPnP IDG & PCP
    1. Enable - Check
    1. Allow PCP/NAT-PMP Port Mapping - Check
    1. External interface - WAN
    1. Internal interfaces - LAN
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> tailscale -> Press **+**
    1. Action - Pass
    1. Quick - Check
    1. Interface - tailscale
    1. Direction - In
    1. TCP/IP Version - IPv4+IPv6
    1. Protocol - TCP
    1. Source - Any
    1. Destination - This Firewall
    1. Destination port range - HTTP
    1. Description - Allow WebGUI from tailscale interface
    1. Press **Save**
    1. Press **Apply changes**

The rest of the steps assume connecting using tailscale

## VLANs

### Create VLANs

1. OPNSense GUI -> Interfaces -> Devices -> VLAN -> Press **+**
    1. Device - Leave empty
    1. Parent - LAN
    1. VLAN tag - 254
    1. VLAN priority - Best Effort (0, default)
    1. Description - management
    1. Press **Save**
    1. Press **Apply**
1. OPNSense GUI -> Interfaces -> Devices -> VLAN -> Press **+**
    1. Device - Leave empty
    1. Parent - LAN
    1. VLAN tag - 2
    1. VLAN priority - Best Effort (0, default)
    1. Description - host
    1. Press **Save**
    1. Press **Apply**
1. OPNSense GUI -> Interfaces -> Devices -> VLAN -> Press **+**
    1. Device - Leave empty
    1. Parent - LAN
    1. VLAN tag - 3
    1. VLAN priority - Best Effort (0, default)
    1. Description - VM
    1. Press **Save**
    1. Press **Apply**
1. OPNSense GUI -> Interfaces -> Devices -> VLAN -> Press **+**
    1. Device - Leave empty
    1. Parent - LAN
    1. VLAN tag - 4
    1. VLAN priority - Best Effort (0, default)
    1. Description - kubernetes
    1. Press **Save**
    1. Press **Apply**
1. OPNSense GUI -> Interfaces -> Devices -> VLAN -> Press **+**
    1. Device - Leave empty
    1. Parent - LAN
    1. VLAN tag - 5
    1. VLAN priority - Best Effort (0, default)
    1. Description - connector
    1. Press **Save**
    1. Press **Apply**

### Create interfaces for the VLANs

1. OPNSense GUI -> Interfaces -> Assignments -> Assign a new interface
    1. Device - VLAN management
    1. Description - management
    1. Press **Add**
1. OPNSense GUI -> Interfaces -> Assignments -> Assign a new interface
    1. Device - VLAN host
    1. Description - host
    1. Press **Add**
1. OPNSense GUI -> Interfaces -> Assignments -> Assign a new interface
    1. Device - VLAN VM
    1. Description - VM
    1. Press **Add**
1. OPNSense GUI -> Interfaces -> Assignments -> Assign a new interface
    1. Device - VLAN kubernetes
    1. Description - kubernetes
    1. Press **Add**
1. OPNSense GUI -> Interfaces -> Assignments -> Assign a new interface
    1. Device - VLAN connector
    1. Description - connector
    1. Press **Add**
1. OPNSense GUI -> Interfaces -> management
    1. Enable - Check
    1. Lock - Check
    1. IPv4 Configuration Type - Static IPv4
    1. IPv4 address - 172.16.254.1/24
    1. IPv4 gateway rules - Disabled
    1. Press **Save**
    1. Press **Apply Changes**
1. OPNSense GUI -> Interfaces -> host
    1. Enable - Check
    1. Lock - Check
    1. IPv4 Configuration Type - Static IPv4
    1. IPv4 address - 172.16.2.1/24
    1. IPv4 gateway rules - Disabled
    1. Press **Save**
    1. Press **Apply changes**
1. OPNSense GUI -> Interfaces -> VM
    1. Enable - Check
    1. Lock - Check
    1. IPv4 Configuration Type - Static IPv4
    1. IPv4 address - 172.16.3.1/24
    1. IPv4 gateway rules - Disabled
    1. Press **Save**
    1. Press **Apply changes**
1. OPNSense GUI -> Interfaces -> kubernetes
    1. Enable - Check
    1. Lock - Check
    1. IPv4 Configuration Type - Static IPv4
    1. IPv4 address - 172.16.4.1/24
    1. IPv4 gateway rules - Disabled
    1. Press **Save**
    1. Press **Apply changes**
1. OPNSense GUI -> Interfaces -> connector
    1. Enable - Check
    1. Lock - Check
    1. IPv4 Configuration Type - Static IPv4
    1. IPv4 address - 172.16.5.1/24
    1. IPv4 gateway rules - Disabled
    1. Press **Save**
    1. Press **Apply changes**

### Create Rules for the VLANs

For each VLAN we are creating firewall rules to make sure that the VLAN can't access the OPNSense management interface or the home network or other VLANs, but can access the local gateway for DNS and the internet

#### VLAN host

1. OPNSense GUI -> Firewall -> Rules -> host -> Press **+**
    1. Action - Block
    1. Interface - host
    1. Direction - in
    1. TCP/IP Version - IPv4+IPv6
    1. Protocol - TCP/UDP
    1. Source - host net
    1. Source port range - any
    1. Destination - host address
    1. Destination port range - HTTP
    1. Description - Block OPNSense WebGUI access
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> host -> Press **+**
    1. Action - Block
    1. Interface - host
    1. Direction - in
    1. TCP/IP Version - IPv4+IPv6
    1. Protocol - TCP/UDP
    1. Source - host net
    1. Source port range - any
    1. Destination - host address
    1. Destination port range - HTTPS
    1. Description - Block OPNSense WebGUI access
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> host -> Press **+**
    1. Action - Pass
    1. Interface - host
    1. Direction - in
    1. TCP/IP Version - IPv4
    1. Protocol - TCP/UDP
    1. Source - host net
    1. Destination - host address
    1. Destination port range - DNS
    1. Description - Allow DNS to GW
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> host -> Press **+**
    1. Action - Pass
    1. Interface - host
    1. Direction - in
    1. TCP/IP Version - IPv4
    1. Protocol - Any
    1. Source - host net
    1. Destination - Single host or Network - 0.0.0.0/0
    1. Description - Allow internet access
    1. Gateway - WAN_GW - 192.168.1.1
    1. Press **Save**

#### VLAN VM

1. OPNSense GUI -> Firewall -> Rules -> VM -> Press **+**
    1. Action - Block
    1. Interface - VM
    1. Direction - in
    1. TCP/IP Version - IPv4+IPv6
    1. Protocol - TCP/UDP
    1. Source - VM net
    1. Source port range - any
    1. Destination - VM address
    1. Destination port range - HTTP
    1. Description - Block OPNSense WebGUI access
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> VM -> Press **+**
    1. Action - Block
    1. Interface - VM
    1. Direction - in
    1. TCP/IP Version - IPv4+IPv6
    1. Protocol - TCP/UDP
    1. Source - VM net
    1. Source port range - any
    1. Destination - VM address
    1. Destination port range - HTTPS
    1. Description - Block OPNSense WebGUI access
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> VM -> Press **+**
    1. Action - Pass
    1. Interface - VM
    1. Direction - in
    1. TCP/IP Version - IPv4
    1. Protocol - TCP/UDP
    1. Source - VM net
    1. Destination - VM address
    1. Destination port range - DNS
    1. Description - Allow DNS to GW
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> VM -> Press **+**
    1. Action - Pass
    1. Interface - VM
    1. Direction - in
    1. TCP/IP Version - IPv4
    1. Protocol - Any
    1. Source - VM net
    1. Destination - Single host or Network - 0.0.0.0/0
    1. Description - Allow internet access
    1. Gateway - WAN_GW - 192.168.1.1
    1. Press **Save**

#### VLAN Connector

1. OPNSense GUI -> Firewall -> Rules -> connector -> Press **+**
    1. Action - Block
    1. Interface - connector
    1. Direction - in
    1. TCP/IP Version - IPv4+IPv6
    1. Protocol - TCP/UDP
    1. Source - connector net
    1. Source port range - any
    1. Destination - connector address
    1. Destination port range - HTTP
    1. Description - Block OPNSense WebGUI access
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> connector -> Press **+**
    1. Action - Block
    1. Interface - connector
    1. Direction - in
    1. TCP/IP Version - IPv4+IPv6
    1. Protocol - TCP/UDP
    1. Source - connector net
    1. Source port range - any
    1. Destination - connector address
    1. Destination port range - HTTPS
    1. Description - Block OPNSense WebGUI access
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> connector -> Press **+**
    1. Action - Pass
    1. Interface - connector
    1. Direction - in
    1. TCP/IP Version - IPv4
    1. Protocol - TCP
    1. Source - connector net
    1. Source port range - any
    1. Destination - host net
    1. Destination port range - (other) - 8006
    1. Description - Allow remote HTTPS access to Proxmox host from connector
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> connector -> Press **+**
    1. Action - Pass
    1. Interface - connector
    1. Direction - in
    1. TCP/IP Version - IPv4
    1. Protocol - TCP
    1. Source - connector net
    1. Source port range - any
    1. Destination - host net
    1. Destination port range - SSH
    1. Description - Allow remote SSH access to Proxmox host from connector
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> connector -> Press **+**
    1. Action - Pass
    1. Interface - connector
    1. Direction - in
    1. TCP/IP Version - IPv4
    1. Protocol - TCP
    1. Source - connector net
    1. Source port range - any
    1. Destination - VM net
    1. Destination port range - SSH
    1. Description - Allow remote SSH access to VMs
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> connector -> Press **+**
    1. Action - Pass
    1. Interface - connector
    1. Direction - in
    1. TCP/IP Version - IPv4
    1. Protocol - TCP
    1. Source - connector net
    1. Source port range - any
    1. Destination - VM net
    1. Destination port range - 6443
    1. Description - Allow remote Kubernetes access to VMs
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> connector -> Press **+**
    1. Action - Pass
    1. Interface - connector
    1. Direction - in
    1. TCP/IP Version - IPv4
    1. Protocol - TCP
    1. Source - connector net
    1. Source port range - any
    1. Destination - VM net
    1. Destination port range - 8443
    1. Description - Allow remote Kubernetes VIP access to VMs
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Aliases -> Press **+**
    1. Enabled - Check
    1. Name - kubernetes_services
    1. Type - Host(s)
    1. Content - 172.16.3.220-172.16.3.254
    1. Authorization - None
    1. Press Save
1. OPNSense GUI -> Firewall -> Rules -> connector -> Press **+**
    1. Action - Pass
    1. Interface - connector
    1. Direction - in
    1. TCP/IP Version - IPv4
    1. Protocol - TCP
    1. Source - connector net
    1. Source port range - any
    1. Destination - Kubernetes_services
    1. Destination port range - any
    1. Description - Allow remote Kubernetes LoadBalancer services access
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> connector -> Press **+**
    1. Action - Pass
    1. Interface - connector
    1. Direction - in
    1. TCP/IP Version - IPv4
    1. Protocol - TCP/UDP
    1. Source - connector net
    1. Destination - connector address
    1. Destination port range - DNS
    1. Description - Allow DNS to GW
    1. Press **Save**
1. OPNSense GUI -> Firewall -> Rules -> connector -> Press **+**
    1. Action - Pass
    1. Interface - connector
    1. Direction - in
    1. TCP/IP Version - IPv4
    1. Protocol - Any
    1. Source - connector net
    1. Destination - Single host or Network - 0.0.0.0/0
    1. Description - Allow internet access
    1. Gateway - WAN_GW - 192.168.1.1
    1. Press **Save**
    1. Press **Apply changes**

## DNS

I configured the OPNSense firewall as a DNS server in order for the VLANs to get DNS requests only from within their network without requiring communication outside of the VLAN

1. OPNSense GUI -> System -> Settings -> General
    1. DNS Server - 192.168.1.1 (home router address)
    1. Use gateway - none
    1. Press **Save**
1. OPNSense GUI -> Services -> Unbound DNS -> General
    1. Enable Unbound - Check
    1. Listen Port - Leave blank
    1. Network Interfaces - All
    1. Press the start button at the top
    1. Press **Apply**

## Firewall Access

When accessing the firewall via tailscale:

1. Type the IP or DNS of the firewall that tailscale assigned in the browser

When accessing the firewall via the management VLAN:

1. Connect a computer to a management port on the smart switch (any port assigned to VLAN 254)
1. Set network settings on the computer:
    1. IPv4 configuration - manual
    1. IP Address - any IP in the 172.16.254.2-254 range
    1. Subnet mask - 255.255.255.0
    1. Default gateway - 172.16.254.1
1. On the computer In the web browser go to [http://172.16.254.1](http://172.16.254.1)
