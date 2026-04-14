---
title: 'Configure Insecure TLS Registry'
draft: false
weight: 2
series: ["K3S"]
series_order: 2
---

This tutorial explains how to configure K3S to pull Docker images from a registry with insecure TLS.

On each node in the cluster that needs to pull Docker images from a registry with insecure TLS, edit the file `/etc/rancher/k3s/registries.yaml` to have the following data:

```yaml
mirrors:
  <registry-name>:
    endpoints:
      - "<registry-url>"
configs:
  <registry-name>:
    tls:
      insecure_skip_verify: true
```

- `registry-name` - The name of the registry without the protocol, e.g. `artifactory.dom.com`
- `registry-url` - The name of the registry with the protocol, e.g. `https://artifactory.dom.com`

Then restart the K3S service on the node (`systemctl restart k3s` on managers, `systemctl restart k3s-agent` on workers).
