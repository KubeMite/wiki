---
title: 'Proxmox Install'
draft: false
weight: 4
series: ["Homelab"]
series_order: 4
---

As my virtualization host I use a [GMKteck NucBox M5 plus](https://www.gmktec.com/products/amd-ryzen-7-5825u-mini-pc-nucbox-m5-plus?variant=10dbb22c-4c99-488f-be78-43c01e2a0c2c) with 32GB ram and 1TB NVME SSD.

I use it to host Proxmox.

## Bios Setup

1. Power on the MiniPC
1. On boot press the **Delete** key to enter Bios
1. Enable auto power on after power loss - Bios -> Advanced -> Auto Power On -> Power On
1. Disable wifi - Bios -> Advanced -> I/O Port Access -> Wireless LAN -> Disabled
1. Disable on board audio - Bios -> Advanced -> I/O Port Access -> OnBoard audio -> Disabled
1. Bios -> Save & Exit -> Save Changes and Exit

## Proxmox Install

First we need to prepare the Proxmox ISO:

1. Download the latest ISO from the [official download page](https://www.proxmox.com/en/downloads/proxmox-virtual-environment). I downloaded version 9.1
1. Make sure the checksum is correct:

    ```sh
    sha256sum proxmox-ve_9.1-1.iso
    ```

   Then compare it to the sha256sum on the downloads page

1. Use [Rufus](https://rufus.ie/en/) to burn the ISO to a USB (select the USB device and the ISO image, then press **START**)
1. Eject the USB from the PC

Then we need to boot into Proxmox:

1. Connect the Proxmox USB into the MiniPC
1. Connect the MiniPC into an ethernet port connected to the internet
1. Power on the MiniPC
1. On boot press the **F7** key to enter boot device selection, then select the USB device
1. On the Proxmox boot menu screen press:
    1. Press **Install Proxmox VE (Graphical)**
    1. END USER LICENSE AGREEMENT (EULA) - **I agree**
    1. Hard disk detection - Choose a hard disk and then press **Next** (I only have a single ssd so choosing ZFS over EXT4 won't give me much benefit and will only wear my SSD faster)
    1. Location and Time Zone selection:
        1. Country - Israel
        1. Time Zone - Asia/Jerusalem
        1. Keyboard Layout - U.S. English
        1. Press Next
    1. Administration Password and Email Address
        1. Password - generate a password and store it somewhere safe
        1. Email - [proxmox-admin@network.internal](mailto:proxmox-admin@network.internal)
    1. Management Network Configuration
        1. Management Interface - Select the interface your ethernet cable is not connected to on the MiniPC (nic1)
        1. Hostname - pve.network.internal
        1. IP Address (CIDR) - 172.16.2.10/24
        1. Gateway - 172.16.2.1
        1. DNS Server - 172.16.2.1
        1. Pin network interface names - Check, make sure that the current connected interface is called **nic0**
        1. Press **Next**
    1. Summary - Press **Install**
    1. Remove the Proxmox install USB
    1. Change the connected interface to nic1

## Initial Setup

First we need to connect to Proxmox locally:

1. Connect a computer to the any port that is not a management port on the smart switch
1. On that computer set an IP of 172.16.2.11/24, and gateway and DNS server of 172.16.2.1
1. In the browser go to [https://172.16.2.10:8006](https://172.16.2.10:8006)
1. Proxmox Gui -> pve -> Updates -> Repositories
    1. Disable [https://enterprise.proxmox.com/debian/ceph-squid](https://enterprise.proxmox.com/debian/ceph-squid)
    1. Disable [https://enterprise.proxmox.com/debian/pve](https://enterprise.proxmox.com/debian/pve)
    1. Press **Add** -> Repository - No-Subscription -> Press **Add**
1. Proxmox Gui -> pve -> Updates -> Press **Refresh**
1. Proxmox Gui -> pve -> Updates -> Press **Upgrade** -> Type **Y** then press **Enter**
1. Reboot the node for updates to take effect
1. Proxmox Gui -> pve -> local -> ISO Images -> Download from URL
    1. URL - Use the Debian full install file download link from [the official download location](https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/) (this link shows the latest Debian version available)
    1. File name - press **Query URL** to fill the file name
    1. Click Advanced
    1. Hash algorithm - SHA-512
    1. Checksum - paste the checksum from the download link
    1. Verify certificates - Check
    1. Decompression algorithm - none
    1. Press Download
1. Now you can create new VMs using this ISO image
1. Now we will enable SSH access to the proxmox node
    1. On the MiniPC install openssh server (if it doesn't exist yet):

        ```sh
        apt install openssh-server
        ```

    2. On the MiniPC in `/etc/ssh/sshd_config.d/hardening.conf` put the following:

        ```text
        # Cryptography
        Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
        KexAlgorithms sntrup761x25519-sha512@openssh.com,mlkem768x25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256
        MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com

        # Authentication & Access Control
        PermitRootLogin yes
        PasswordAuthentication no
        PubkeyAuthentication yes
        PermitEmptyPasswords no
        MaxAuthTries 3
        LoginGraceTime 60
        HostbasedAuthentication no
        IgnoreRhosts yes

        # Session & Connection Management
        MaxSessions 2
        MaxStartups 10:30:60
        TCPKeepAlive no
        ClientAliveInterval 150
        ClientAliveCountMax 2
        Compression no

        # Restriction & Forwarding
        DisableForwarding yes
        AllowAgentForwarding no
        AllowTcpForwarding no
        X11Forwarding no
        PermitUserEnvironment no

        # Logging & UI
        Banner /etc/issue
        LogLevel VERBOSE
        ```

    3. On the MiniPC restart the ssh service for the changes to take effect:

        ```sh
        systemctl restart ssh
        ```

    4. On your computer generate an ssh key-pair:

        ```sh
        ssh-keygen -t ed25519 -b 521 -C test -f id_ed25519_test -N ""
        ```

    5. On the MiniPC copy the public key to the authorized keys

        ```sh
        echo "<public-key-content>" >> /root/.ssh/authorized_keys
        ```

    6. Store the public key in Bitwarden secret manager under the name `proxmox-root-ssh-public-key`, and the private key under the name `proxmox-root-ssh-private-key`

## Remote Access

For remote access we will use tailscale on a proxmox VM in a different VLAN, and only allow specific ports to communicate to the **host** VLAN. This ensures isolation between remote access to full Proxmox control.

First we need to connect to Proxmox locally:

1. Connect a computer to the smart switch in a port that is assigned to the same VLAN as the Proxmox host
1. On the computer set the following network settings for the interface connected to the switch:
    1. IP - 172.16.2.100
    1. Subnet - 255.255.255.0
    1. Default Gateway - 172.16.2.1
1. On the computer in the browser go to [http://172.16.2.10:8006](http://172.16.2.10:8006) (the IP of the proxmox host) and log in
1. Proxmox Gui -> pve -> Create VM
    1. General
        1. Node - pve
        1. VM ID - 100
        1. Name - connector
        1. Check **Advanced**
        1. Check **Start at boot**
        1. Press **Next**
    1. OS
        1. Check **Use CD/DVD disc image file (iso)**
        1. ISO Image - The downloaded ISO image
        1. Type - Linux
        1. Version - latest kernel
        1. Press **Next**
    1. System
        1. Graphics card - Default
        1. SCSI Controller - VirtIO SCSI single
        1. Machine - Default (i440fx)
        1. Qemu Agent - Check
        1. BIOS - Default (SeaBIOS)
        1. Press **Next**
    1. Disks
        1. Storage - local-vlm
        1. Disk size (GiB) - 20
        1. Backup - Check
        1. Press **Next**
    1. CPU
        1. Sockets - 1
        1. Cores - 1
        1. Type - x86-64-v2-AES
        1. Press **Next**
    1. Memory
        1. Memory - 2048
        1. Press **Next**
    1. Network
        1. VLAN Tag - 5 (the Proxmox remote access VLAN)
        1. Press **Next**
    1. Confirm
        1. Start after created - Check
        1. Press **Finish**
1. Proxmox Gui -> pve -> 100 (connector) -> Options -> Protection - Yes
1. Proxmox Gui -> pve -> 100 (connector) -> Console
    1. Graphical install
    1. Select a language - English
    1. Select your location - Israel
    1. Configure the keyboard - American English
    1. Configure network manually
        1. IP address - 172.16.5.10/24
        1. Gateway - 172.16.5.1
        1. Name server address - 172.16.5.1
        1. hostname - connector
        1. Domain name - network.internal
    1. Set up users and passwords
        1. Root password - generate and keep in a password manager
        1. Username - user
        1. User password - generate and keep in a password manager
    1. Partition disks
        1. Guided - use entire disk and set up LVM
        1. Select the disk
        1. Separate /home, /var and /tmp partitions
        1. Yes
        1. Enter size of entire disk
        1. Yes
        1. Finish partitioning and write changes to disk
        1. Yes
    1. Configure the package manager
        1. Scan extra installation media - No
        1. Use a network mirror - Yes
        1. Debian archive mirror country - Israel
        1. Debian archive mirror - deb.debian.org
        1. HTTP proxy information - Leave blank
        1. Participate in the package usage survey - No
        1. Choose software to install - Enable **standard system utilities**. Disable everything else
        1. Install the GRUB boot loader to your primary drive - Yes, then choose the only available drive
    1. Finish the installation and log in as user then escalate to root (`su -`)
    1. Remove the CD repository on the VM by prepending the first line in the file **/etc/apt/sources.list** with a #
    1. Change to https in sources.list:

        ```sh
        sed -i 's/http/https/g' /etc/apt/sources.list
        ```

    1. Update & upgrade packages:

        ```sh
        apt update && apt upgrade
        ```

    1. Install required tools on the VM:

        ```sh
        apt install curl vim -y
        ```

    1. Install tailscale on the VM:

        ```sh
        curl -fsSL https://tailscale.com/install.sh | sh
        ```

    1. Start tailscale on the VM:

        ```sh
        tailscale up
        ```

        Then go to the URL posted on the screen and log in with your account

    1. Install and configure automatic system upgrade for critical packages:

        1. Install the required packages:

            ```sh
            apt update && apt install unattended-upgrades apt-listchanges -y
            ```

        1. Configure auto-upgrades by making sure the following lines are in **/etc/apt/apt.conf.d/20auto-upgrades**:

            ```text
            APT::Periodic::AutocleanInterval "7";
            APT::Periodic::Update-Package-Lists "1";
            APT::Periodic::Unattended-Upgrade "1";
            ```

        1. Configure unattended-upgrades by making sure the following lines are in **/etc/apt/apt.conf.d/50unattended-upgrades**:

            ```text
            Unattended-Upgrade::Origins-Pattern {
              "origin=Debian,codename=${distro_codename},label=Debian";
              "origin=Debian,codename=${distro_codename}-security,label=Debian-Security";
              "origin=Debian,codename=${distro_codename},label=Debian-Security";
            };
            Unattended-Upgrade::Remove-Unused-Dependencies "true";
            Unattended-Upgrade::Automatic-Reboot "false";
            ```

        1. Enable and start the unattended-upgrades service:

            ```sh
            systemctl restart unattended-upgrades
            systemctl enable --now unattended-upgrades
            ```

    1. Make sure the connector VM can forward packets:

        ```sh
        echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
        echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
        sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
        ```

        Then reboot the connector VM for the changes to take effect

    1. Publish the route to the Proxmox host and to the VM subnet:

        ```sh
        tailscale set --advertise-routes=172.16.2.10/32,172.16.3.0/24
        ```

1. Tailscale GUI -> Machines -> connector -> Subnets - Accept the new routes and make sure  they enabled in the access controls
1. Now we will lower the amount of memory the connector VM uses

    Proxmox GUi -> pve -> 100 (connector) -> Hardware -> Memory -> Edit

    1. Memory (MiB) - 2048
    1. Minimum memory (MiB) - 1024
    1. Ballooning Device - Check

1. For the memory change to take effect we need to reboot the connector VM
   Proxmox GUi -> pve -> 100 (connector) -> Shutdown -> Reboot
1. You can now access proxmox remotely both from the website (HTTPS) and from the CLI (SSH)!

## Post Setup

1. Go to Proxmox GUI -> Shell
1. Install extra packages:

    ```sh
    apt install tcpdump htop curl wget ncdu net-tools vim -y
    ```

1. Disable the Proxmox subscription message:
    1. Create a backup of the proxmox widget javascript file:

        ```sh
        cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.backup
        ```

    1. Edit the `/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js`:

        Change this line of code:

        ```javascript
        res.data.status.toLowerCase() !== 'active'
        ```

        To this line of code:

        ```javascript
        res.data.status.toLowerCase() == 'active'
        ```

    1. Restart the proxmox proxy service:

        ```sh
        systemctl restart pveproxy.service
        ```

    1. Log back in again and make sure that the popup for the subscription doesn't occur

1. Install and configure automatic system upgrade for critical packages:
    1. Install the required packages:

        ```sh
        apt update && apt install unattended-upgrades apt-listchanges -y
        ```

    1. Configure auto-upgrades by making sure the following lines are in **/etc/apt/apt.conf.d/20auto-upgrades**:

        ```text
        APT::Periodic::AutocleanInterval "7";
        APT::Periodic::Update-Package-Lists "1";
        APT::Periodic::Unattended-Upgrade "1";
        ```

    1. Configure unattended-upgrades by making sure the following lines are in **/etc/apt/apt.conf.d/50unattended-upgrades**:

        ```text
        Unattended-Upgrade::Origins-Pattern {
          "origin=Debian,codename=${distro_codename},label=Debian";
          "origin=Debian,codename=${distro_codename}-security,label=Debian-Security";
          "origin=Debian,codename=${distro_codename},label=Debian-Security";
        };
        Unattended-Upgrade::Remove-Unused-Dependencies "true";
        Unattended-Upgrade::Automatic-Reboot "false";
        ```

    1. Enable and start the unattended-upgrades service:

        ```sh
        systemctl restart unattended-upgrades
        systemctl enable --now unattended-upgrades
        ```

1. Now our Proxmox node is configured! It is hardened and can be accessed remotely

## Packer & Terraform

In order to use Packer and Terraform to provision VMs in Proxmox, we need to create an API token and a snippets directory:

1. Proxmox GUI -> Datacenter -> Permissions -> API Tokens -> Add
    1. User - root@pam
    1. Token ID - api-access
    1. Privilege Separation - Uncheck
    1. Expire - never
    1. Press **Add**
1. In Bitwarden secret manager store the token ID and secret:
    1. Store the token ID under the secret name `proxmox-root-api-token-id`
    1. Store the secret under the secret name `proxmox-root-api-token-secret`
1. Proxmox GUI -> Datacenter -> Storage -> Local -> Edit
    1. Content - Add snippets
    1. Press **OK**

## Set the single Proxmox node as a cluster

We should cluster our Proxmox node to add more nodes later

1. Proxmox GUI -> Datacenter -> Cluster -> Create Cluster
    1. Cluster Name: MyCluster
    1. Cluster Network: Leave default
    1. Press **Create**
