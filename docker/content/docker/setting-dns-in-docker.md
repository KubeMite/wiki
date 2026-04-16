---
title: 'Setting DNS in Docker'
draft: false
series: ["Docker"]
---

This tutorial details how to change the DNS server for containers running using the Docker daemon, regardless of what is set on the server running the Docker daemon

Edit the `/etc/docker/daemon.json` file:

```json
{
  "dns": ["<first-dns-server>", "<second-dns-server>", "<third-dns-server>"]
}
```

Then restart the Docker service to ensure that the changes will take effect:

```sh
systemctl restart docker
```
