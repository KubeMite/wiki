---
title: 'VM Setup'
draft: false
weight: 5
series: ["Homelab"]
series_order: 5
---

I created [this repo](https://github.com/KubeMite/kubernetes-golden-image ) to setup my VM template using [Packer](https://developer.hashicorp.com/packer)

The Packer code builds a Debian ISO image that is hardened and pre-installed with everything necessary to setup a Kubernetes cluster.

I decided to use Packer in order to simplify and track my ISOs, so that I can correlate a git commit hash with the exact ISO.

I use Github Actions in order to build the images automatically, and name them after their git branch and commit hash.\
Each Github runner connects to my tailscale network in order to access my Proxmox server.\
You can see the github actions runs [in this page](https://github.com/KubeMite/kubernetes-golden-image/actions).

## Building

All of the secrets for the build are stored in Bitwarden secret manager. In order to access it via the API I created the required API secrets using these steps:

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

### Running the build manually

1. Connect to the tailscale network with the correct ACL permissions
1. Clone this repo:

    ```sh
    git clone https://github.com/KubeMite/kubernetes-golden-image.git
    ```

1. Run the Packer devcontainer
1. Follow the instructions in the README file

### Setting up the build in CI/CD

In order to run the build automatically I use Github Actions since the code is already posted in Github

1. First I created secrets containing what is needed to connect to the Bitwarden secret manager secrets
    1. Github -> KubeMite organization -> Settings -> Secrets and variables -> Actions -> Secrets -> New organization secret
        1. Name: BWS_ACCESS_TOKEN
        1. Value: The machine account access token
    1. Github -> KubeMite organization -> Settings -> Secrets and variables -> Actions -> Secrets -> New organization secret
        1. Name: BWS_PROJECT_ID
        1. Value: The UUID of the project the machine account access token
1. Then I created secrets to connect to my tailscale network from a Github runner
    1. Tailscale admin panel -> Settings -> Trust credentials -> press **+ Credential** -> OAuth
        1. Scopes - Under keys give read & write permissions to **OAuth Keys**
        1. Tags - Create a CI tag and add it here
        1. Press **Generate credential**
        1. Copy the **Client ID** & **Client secret**
    1. Github -> KubeMite organization -> Settings -> Secrets and variables -> Actions -> Secrets -> New organization secret
        1. Name: TS_CLIENT_ID
        1. Value: The tailscale client ID
    1. Github -> KubeMite organization -> Settings -> Secrets and variables -> Actions -> Secrets -> New organization secret
        1. Name: TS_CLIENT_SECRET
        1. Value: The tailscale client secret
1. Then I made sure to provide access in the tailscale ACL for the CI tag to access the proxmox host via port 22 & 8006

Now the CI/CD can run and build the VM template!
