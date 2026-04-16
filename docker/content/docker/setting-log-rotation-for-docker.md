---
title: 'Setting Log Rotation for Docker'
draft: false
series: ["Docker"]
---

By default the Docker daemon writes container logs to the host server. There is no log rotation set by default which can fill up the host OS, so it should be configured.\
To ensure that logs won't fill the machine that Docker is installed in, we'll set how many log files the Docker daemon can create at one time and the max size of each file.

Edit the `/etc/docker/daemon.json` file:

```json
{
  "log-opts": {
    "max-size": "15m",
    "max-file": "5"
  }
}
```

- **max-size:** defines the max size of each log file before its logs will be written to a new log file.
- **max-file:** defines the amount of logs files that can exists simultaneously before the oldest file will be deleted.

Then restart the Docker daemon for the changes to take effect:

```sh
sudo systemctl restart docker
```

The changes will only take effect for containers created after the restart of the docker service. Running containers will have to be deleted and re-created, restarting them won't help as long as it's the same container.

It is recommended to setup a log shipper to send the log files to a central storage.
