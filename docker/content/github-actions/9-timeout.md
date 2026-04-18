---
title: 'Timeout'
draft: false
weight: 9
series: ["Github Actions"]
series_order: 9
---

By default, Github Actions kills any workflow running for more than 6 hours.\
We many want to ensure that a workflow won't run for too long in order to conserve usage or ensure that third party services are accessible.

We use `timeout-minutes` to specify the timeout for a job or a step.

```yaml
name: my-workflow

on:
  push

jobs:
  docker:
    runs-on: ubuntu-latest

    steps:
      - name: Docker Build
        env:
          CONTAINER_REGISTRY: docker.io
          DOCKER_USERNAME: my-username
          IMAGE_NAME: my-image
        run: docker build -t $CONTAINER_REGISTRY/$DOCKER_USERNAME/$IMAGE_NAME:latest

      - name: Docker Login
        env:
          DOCKER_USERNAME: my-username
          DOCKER_PASSWORD: my-password
        run: docker login --username=$DOCKER_USERNAME --password=$DOCKER_PASSWORD

      - name: Docker Publish
        env:
          CONTAINER_REGISTRY: docker.io
          DOCKER_USERNAME: my-username
          IMAGE_NAME: my-image
        timeout-minutes: 1
        run: docker push ${{ env.CONTAINER_REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest

  deploy:
      runs-on: ubuntu-latest

      needs: docker

      timeout-minutes: 1

      steps:
        - name: Deploy docker image
          env:
            CONTAINER_REGISTRY: docker.io
            DOCKER_USERNAME: my-username
            IMAGE_NAME: my-image
          run: docker run -d -p 8080:80 ${{ env.CONTAINER_REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest
```
