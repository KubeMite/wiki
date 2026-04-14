---
title: 'Kubernetes cluster setup'
draft: false
weight: 6
series: ["Homelab"]
series_order: 6
---

I created [this repo](https://github.com/KubeMite/kubernetes-cluster-creation) to setup my Kubernetes cluster using [Terraform](https://developer.hashicorp.com/terraform).

The Terraform code creates multiple VMs from a Proxmox VM template created using [this repo](https://github.com/KubeMite/kubernetes-golden-image).

## Kubernetes Components

My Kubernetes cluster is composed of multiple parts: the CRI (container runtime interface), the CNI (container network interface), the CSI (container storage interface) and some other tools to provide additional functionality.

### CRI

For the container runtime interface I decided to use [containerd](https://containerd.io/) since it seemed like the simplest option that will work reliably, and is the de-facto standard.

### CNI

For the container network interface I decided to use [cilium](https://cilium.io/). It supports a lot of features (including encryption, NetworkPolicy, and L2announcement), is widely used and works on the kernel level using eBPF to deliver great performance.

#### Encryption

I configured Cilium to use [WireGuard](https://www.wireguard.com/) so that inter-cluster communication is end-to-end encrypted! More info can be found in [the official documentation](https://docs.cilium.io/en/stable/security/network/encryption-wireguard/).

#### L2Announcement

I access some services from outside of the cluster by using the [L2announcement](https://docs.cilium.io/en/stable/network/l2-announcements/) feature of Cilium. This feature allows access to a service from outside of a cluster over ARP in the same network, which is perfect for me since I already access my cluster network using Tailscale.

This is the configuration I had to do to make it work:

1. Create an L2 announcement policy so that Cilium will know to announce the external LoadBalancer IPs

    ```yaml
    apiVersion: cilium.io/v2alpha1
    kind: CiliumL2AnnouncementPolicy
    metadata:
      name: loadbalancer-ip-external-access
    spec:
      # Selects all linux nodes
      nodeSelector:
        matchExpressions:
          - key: kubernetes.io/os
            operator: In
            values:
              - linux
      # Selects all interfaces starting with ens
      interfaces:
      - ^ens[0-9]+
      loadBalancerIPs: true
    ```

    I didn't include a `serviceSelector` since I want all LoadBalancer services to be publicly accessible

1. Create an IP pool for cilium to hand external LoadBalancer IPs from:

    ```yaml
    apiVersion: "cilium.io/v2"
    kind: CiliumLoadBalancerIPPool
    metadata:
      name: "<ip-pool-name>"
    spec:
      blocks:
        - start: "<first-ip>"
          stop: "<last-ip>"
    ```

1. For a service that is supposed to be accessible from outside of the cluster I set the service type to `LoadBalancer`, and add the following annotation: `io.cilium/lb-ipam-ips: <service-external-ip>`. As long as the requested service external IP is in the IP pool and is not allocated yet, the service will get that IP

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: my-service
      annotations:
        io.cilium/lb-ipam-ips: "<service-external-ip>"
    spec:
      selector:
        app.kubernetes.io/name: MyApp
      ports:
        - protocol: TCP
          port: 80
          targetPort: 9376
      type: LoadBalancer
    ```

### CSI

For the container storage interface I chose [seaweedfs](https://seaweedfs.com/). I wanted a solution that is stable, resource efficient and supports local storage with replication.

- I tried [longhorn](https://longhorn.io/) but encountered weird bugs when deleting containers.
- I tried Rook+Ceph (which is the industry standard ) but my nodes are pretty small and couldn't handle the resource requirements.
- I tried [proxmox-csi-plugin](https://github.com/sergelogvinov/proxmox-csi-plugin) but that required API access to the proxmox host from the VMs which I didn't feel comfortable with.

At the end I decided to go with seaweedfs because of the above reasons and because it is made to handle billions of small files, which is what a lot of filesystems are.

### Cert-Manager

I use [cert-manager](https://cert-manager.io/) to handle all of the application certificates in the cluster. Wether it is a self-signed certificate for the external-secrets bitwarden SDK or an ACME let's encrypt certificate for my website, it does it all.

### External-Secrets

I use [external-secrets](https://external-secrets.io/) to dynamically fetch secrets from [Bitwarden Secret Manager](https://bitwarden.com/products/secrets-manager/) using the [Bitwarden Secrets Manager Provider](https://external-secrets.io/latest/provider/bitwarden-secrets-manager/#external-secret-store). This means that I can create an ExternalSecret object and reference the secret UUID from Bitwarden Secret Manager and a corresponding secret will be created in the cluster with the correct information.

For example, this resource:

```yaml
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: example-secret
  namespace: default
spec:
  refreshInterval: 1h0m0s
  secretStoreRef:
    name: bitwarden-secretsmanager
    kind: ClusterSecretStore
  data:
    - secretKey: user_password
      remoteRef:
        key: 12345678-1234-1234-1234-0123456789ab
    - secretKey: root_password
      remoteRef:
        key: 01234567-0123-0123-0123-123456789abc
```

Will create this secret (and manage its lifecycle):

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: example-secret
  namespace: default
type: Opaque
data:
  user_password: eW91dGhvdWdodGlsZWFrZWRteXBhc3N3b3JkPwo=
  root_password: dGhpbmthZ2Fpbgo=
```

I only use UUIDs and not secret names since searching by secret names is both less secure (re-creating the secret will result in the UUID changing) and requires more API calls.

### ArgoCD

I use ArgoCD to deploy all of my applications (everything that ArgoCD doesn't require in order to run).

All of my configuration files for telling ArgoCD how to run my applications live in this repo: [https://github.com/KubeMite/gitops](https://github.com/KubeMite/gitops).

I decided not to use separate dev and prod directories since I don't have enough hardware in my Proxmox cluster to have two instances of my apps. Once I upgrade my hardware I will separate the environments, and maybe I will even use a new environment for each PR to main!

## Building the cluster

All of the secrets for the build process are stored in Bitwarden secret manager. In order to access it via the API I created the required API secrets using these steps:

1. Bitwarden secret manager -> Machine accounts -> New -> Machine account
    1. Machine account name - General Access
    1. Press Save
1. Bitwarden secret manager -> Machine accounts -> General Access
    1. Project - Assign projects to this machine account -> your project -> Press Add -> Permissions -> Can read -> Press Save
    1. Access tokens -> Create access token
        1. Name - General Access
        1. Expires - Enter a date 1 year in the future
        1. Copy the token

And then I got the UUID of the project:

1. Bitwarden secret manager -> Project -> copy the UUID of the project the machine account has access to

### Secrets

In Bitwarden secret manager I created the following secrets for each VM so that the automation can inject the required values to cloud-init when cloning the VM:

- `vm-<hostname>-root-password`
- `vm-<hostname>-user-password`
- `vm-<hostname>-user-ssh-public-key`

And I created the following secrets to bootstrap the cluster:

- `kubernetes-certificate-key` - generated using this command:

    ```sh
    kubeadm certs certificate-key
    ```

- `kubernetes-token` - generated using this command:

    ```sh
    kubeadm token generate
    ```

### Running the build manually

1. Connect to the tailscale network with the correct ACL permissions
1. Clone the above repo:

   ```sh
   git clone https://github.com/KubeMite/kubernetes-golden-image.git
   ```

1. Run the Terraform devcontainer
1. Follow the instructions in the README file
