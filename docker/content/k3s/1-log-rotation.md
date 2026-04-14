---
title: 'Log rotation'
draft: false
weight: 1
series: ["K3S"]
series_order: 1
---

K3S by default comes with log rotation.

In order to configure the log rotation, we simply need to add the following variable to the install command of K3S:

```sh
INSTALL_K3S_EXEC="--kubelet-arg 'container-log-max-files=<max-log-files>' --kubelet-arg 'container-log-max-size=<max-file-size>Mi'"
```

- `max-log-files` - The max amount of logs files that can be created before the oldest one will be deleted.
- `max-file-size` - The max size of a log file before a new one will be written.

Example of an install command with log rotation configured:

```sh
INSTALL_K3S_EXEC="--kubelet-arg 'container-log-max-files=<max-log-files>' --kubelet-arg 'container-log-max-size=<max-file-size>Mi'" ./install.sh agent --server https://<manager-hostname>:6443
```
