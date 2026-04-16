---
title: 'Changing Docker storage location'
draft: false
series: ["Docker"]
---

This tutorial details how to change the storage location of Docker data on a server running Docker

1. Stop the Docker service:

    ```sh
    sudo systemctl stop docker
    ```

1. Edit the Docker daemon configuration file in `/etc/docker/daemon.json`:

    ```json
    {
      "data-root": "<path-to-new-docker-storage>"
    }
    ```

1. Copy the Docker image to the new folder:

    ```sh
    sudo rsync -aP /var/lib/docker/ "<path-to-new-docker-storage>"
    ```

1. Change the original folder name of the Docker data to ensure that docker won't use it anymore:

    ```sh
    sudo mv /var/lib/docker /var/lib/docker.old
    ```

1. Start Docker so that the changes will take effect:

    ```sh
    sudo systemctl start docker
    ```

1. Check that Docker works:

    ```sh
    docker images
    ```

1. Delete the original folder:

    ```sh
    rm -rf /var/lib/docker.old
    ```
