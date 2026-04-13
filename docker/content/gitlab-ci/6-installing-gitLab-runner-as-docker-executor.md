---
title: 'Installing GitLab Runner as Docker Executor'
draft: false
weight: 6
series: ["Gitlab-CI"]
series_order: 6
---

This tutorial shows how to install a GitLab Runner on a server as a Docker executor, meaning that the runner will run as a docker container and each pipeline stage will run on a separate docker container on the same host.

The following tutorial assumes a host with docker installed:

1. Create a folder on the host for the GitLab runner data, and for storing certificates to authenticate with the GitLab instance

    ```sh
    mkdir -p <gitlab-runner-config-dir>/certs
    ```

2. Acquire a certificate for our GitLab instance and put it in the `<gitlab-runner-config-dir>/certs` folder

3. Run a GitLab runner container on the host:

    ```sh
    docker run --name <container-name> \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --mount type=bind,source=<gitlab-runner-config-dir>,target=/etc/gitlab-runner \
    --restart=unless-stopped \
    -d gitlab/gitlab-runner:v<gitlab-version>
    ```

    - The image can also be `gitlab/gitlab-runner:alpine-v<gitlab-version>` if a smaller version is needed.

4. Fetch the registration token from the GitLab repo under setting -> CI/CD.

5. Register the runner to the repo:

    ```sh
    docker exec -it <container-name> gitlab runner register \
    --non-interactive \
    --url <gitlab-instance-url> \
    -r <registration-token> --tls-ca-file /etc/gitlab-runner/certs/gitlab-runner-ca.crt \
    --name <runner-name> --executor docker \
    --docker-privileged --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
    --docker-image <default-image> \
    --docker-helper-image gitlab/gitlab-runner-helper:x86_64-v<gitlab-version>
    ```

    - `default image` is the image that the runner will use in order to run a pipeline stage if no image has been specified.
