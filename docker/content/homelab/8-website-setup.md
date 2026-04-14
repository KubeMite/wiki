---
title: 'Website Setup'
draft: false
weight: 8
series: ["Homelab"]
series_order: 8
---

## Technologies used for the website

- I used [Hugo](https://gohugo.io/) to convert markdown files into HTML and CSS (together with the [blowfish](https://blowfish.page) theme)
- I used [Github](https://github.com/) to store the markdown files, Hugo configuration and CI for docker image creation of the website in this repository: [https://github.com/KubeMite/wiki](https://github.com/KubeMite/wiki) and the helm package to deploy that website in this repository: [https://github.com/KubeMite/wiki-helm](https://github.com/KubeMite/wiki-helm)
- In order to host my website I used my Kubernetes cluster
- For public access I used [cloudflare remote tunnels](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/) and for HTTPS I let cloudflare handle it through the route, which automatically gives my domain a [letsencrypt](https://letsencrypt.org/) certificate
- I synchronize the state of the website with the latest Docker images and helm chart using [ArgoCD](https://argoproj.github.io/cd/)

## Deploying the website through cloudflare tunnels

First I bought my domain through cloudflare

Then I created a [remote tunnel](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/deployment-guides/kubernetes/) to allow cloudflare access to my Kubernetes cluster:

1. I created a tunnel using the cloudflare web GUI -> Networking -> Tunnels -> Create tunnel
1. Then I installed the remote tunnel using Kubernetes manifests in my [GitOps repository](https://github.com/KubeMite/gitops/tree/main/apps/wiki) which deploys it into my cluster (both the tunnel token secret and the tunnel deployment)
1. I configured my tunnel to be able to access my local service for my website by using these steps:
    1. In the tunnel configuration page (cloudflare web GUI -> Networking -> Tunnels) I entered my tunnel and pressed Add route -> Published application
    1. Here I selected my domain (yahav.me) and entered the Kubernetes service URL ([http://wiki-helm](http://wiki-helm))
1. Then I created rules to deny access to the /metrics and /health endpoints by going to cloudflare web GUI -> Domains -> Overview -> yahav.me -> Rules -> Overview. Here I created two redirect rules to redirect from the endpoints to the root. I made sure to put the rules under the `redirect from HTTP to HTTPS` to ensure that the URL the rule will encounter will always come from https
1. Then I created a rule to deny certain countries from accessing my website:
    1. cloudflare web GUI -> Domains -> Overview -> yahav.me -> Security -> Security rules -> Create rule -> Create custom rule
    1. In the rule I blocked requests that match my required countries, then chose the Block action. Then I applied the rule
1. At this point I noticed that some javascript wasn't loading correctly on my website, so I had to disable Rocket Loader:\
    cloudflare web GUI -> Domains -> Overview -> yahav.me -> Speed -> Settings -> Content Optimization -> Rocket Loader -> Disable
