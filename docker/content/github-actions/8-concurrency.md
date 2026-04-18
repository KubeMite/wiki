---
title: 'Concurrency'
draft: false
weight: 8
series: ["Github Actions"]
series_order: 8
---

By default workflows run concurrently, meaning that if one workflow starts and then workflow gets triggered, the new workflow will run regardless of the status of the first workflow.

To alter this behavior we use [concurrency](https://docs.github.com/en/actions/using-jobs/using-concurrency).

Concurrency allows us to specify that only one job or workflow will run at any time, meaning that new workflows or jobs will be pending until the earlier jobs are done.

We can specify concurrency at the the workflow level or the job level by setting the `concurrency` key at the required level.

```yaml
name: <workflow-name>

concurrency: <value>
```

```yaml
name: <workflow-name>

jobs:
  <job-name>:
    concurrency: <value>
```

## Group

Github actions uses the `group` key to ensure that only one instance of that workflow or jobs with the key runs.\
If there are multiple workflows or jobs trying to run with the same concurrency key, only one of them will succeed and the rest will remain in a pending state.\
The next job or workflow to run is chosen in an arbitrary order.

```yaml
name: <workflow-name>

concurrency:
  group: <group-name>
```

```yaml
name: <workflow-name>

jobs:
  <job-name>:
    concurrency:
      group: <group-name>
```

## Cancel-in-Progress

When the `cancel-in-progress` key is set to `true`, a running workflow or job will be cancelled in the event of a newer job with the same `group` key is pending to start

```yaml
name: <workflow-name>

concurrency:
  group: <group-name>
  cancel-in-progress: <true|false>
```

```yaml
name: <workflow-name>

jobs:
  <job-name>:
    concurrency:
      group: <group-name>
      cancel-in-progress: <true|false>
```

## Full Example

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
        run: docker push ${{ env.CONTAINER_REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest

  deploy:
      runs-on: ubuntu-latest

      needs: docker

      concurrency:
        group: deployment
        cancel-in-progress: true

      steps:
        - name: Deploy docker image
          env:
            CONTAINER_REGISTRY: docker.io
            DOCKER_USERNAME: my-username
            IMAGE_NAME: my-image
          run: docker run -d -p 8080:80 ${{ env.CONTAINER_REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest
```
