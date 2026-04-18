---
title: 'Variables and Secrets'
draft: false
weight: 6
series: ["Github Actions"]
series_order: 6
---

We can specify environment variables in different levels of a workflow, and we can use variables and secrets stored in the repository or organization.

## Environment variables

We can use environment variables in three places:

- Step level
- Job level
- Workflow level

We can access environment variable values in two ways:

1. `$<env_name>`
1. `${{ env.<env_name> }}`

It is not recommended to store sensitive values in environment variables inside a workflow since they will be tracked in Git and accessible to anyone who can view the repository. For this reason, secrets are preferred.

Ideally each variable should be declared once, but at the lowest level possible without writing its value multiple times.

### Step Level Environment Variables

Environment variables can be declared at the step level, meaning they will be accessible only at the same step they are defined in.

```yaml
- name: <step-name>
  run: <command>
  env:
    <env-var-name>: <env-var-value>
```

Example of a workflow with environment variables in the step level:

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

      steps:
        - name: Deploy docker image
          env:
            CONTAINER_REGISTRY: docker.io
            DOCKER_USERNAME: my-username
            IMAGE_NAME: my-image
          run: docker run -d -p 8080:80 ${{ env.CONTAINER_REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest
```

### Job Level Environment Variables

Environment variables can be declared at the job level, meaning they will be accessible to all steps in the job they are defined in.

```yaml
jobs:
  <job-name>:
    env:
      <env-var-name>: <env-var-value>
```

Example of a workflow with environment variables in the job level:

```yaml
name: my-workflow

on:
  push

jobs:
  docker:
    runs-on: ubuntu-latest

    env:
      CONTAINER_REGISTRY: docker.io
      DOCKER_USERNAME: my-username
      IMAGE_NAME: my-image

    steps:
      - name: Docker Build
        run: docker build -t $CONTAINER_REGISTRY/$DOCKER_USERNAME/$IMAGE_NAME:latest

      - name: Docker Login
        env:
          DOCKER_PASSWORD: my-password
        run: docker login --username=$DOCKER_USERNAME --password=$DOCKER_PASSWORD

      - name: Docker Publish
        run: docker push ${{ env.CONTAINER_REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest

  deploy:
    runs-on: ubuntu-latest

    env:
    CONTAINER_REGISTRY: docker.io
    DOCKER_USERNAME: my-username
    IMAGE_NAME: my-image

    needs: docker

    steps:
      - name: Deploy docker image
        env:
          CONTAINER_REGISTRY: docker.io
          DOCKER_USERNAME: my-username
          IMAGE_NAME: my-image
        run: docker run -d -p 8080:80 ${{ env.CONTAINER_REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest
```

### Workflow Level Environment Variables

Environment variables can be declared at the workflow level, meaning they will be accessible to all steps in the workflow they are defined in.

```yaml
name: <workflow-name>

env:
  <env-var-name>: <env-var-value>
```

Example of a workflow with environment variables in the workflow level:

```yaml
name: my-workflow

on:
  push

env:
  CONTAINER_REGISTRY: docker.io
  DOCKER_USERNAME: my-username
  IMAGE_NAME: my-image

jobs:
  docker:
    runs-on: ubuntu-latest

    steps:
      - name: Docker Build
        run: docker build -t $CONTAINER_REGISTRY/$DOCKER_USERNAME/$IMAGE_NAME:latest

      - name: Docker Login
        env:
          DOCKER_PASSWORD: my-password
        run: docker login --username=$DOCKER_USERNAME --password=$DOCKER_PASSWORD

      - name: Docker Publish
        run: docker push ${{ env.CONTAINER_REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest

  deploy:
    runs-on: ubuntu-latest

    needs: docker

    steps:
      - name: Deploy docker image
        env:
          CONTAINER_REGISTRY: docker.io
          DOCKER_USERNAME: my-username
          IMAGE_NAME: my-image
        run: docker run -d -p 8080:80 ${{ env.CONTAINER_REGISTRY }}/${{ env.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest
```

## Repository/Organization Variables and Secrets

Secrets are encrypted variables that can be used in workflows. They will not be displayed in logs.\
Secrets and variables stored at the repository level can be accessed by any workflow running in the repository.

We can store secrets and variables at multiple levels:

- The organization level
- The repository level - in the setting page of a repository -> Secrets and Variables -> Actions -> Repository secrets

We can access a secret value in a workflow by using the following syntax: `{{ secrets.<secret_name> }}`\
We can access a variable value in a workflow by using the following syntax: `{{ vars.<variable_name> }}`

```yaml
name: my-workflow

on:
  push

env:
  CONTAINER_REGISTRY: docker.io
  IMAGE_NAME: my-image

jobs:
  docker:
    runs-on: ubuntu-latest

    steps:
      - name: Docker Build
        run: docker build -t $CONTAINER_REGISTRY/${{ vars.DOCKER_USERNAME }}/$IMAGE_NAME:latest

      - name: Docker Login
        run: docker login --username=${{ vars.DOCKER_USERNAME }} --password=${{ secrets.DOCKER_PASSWORD }}

      - name: Docker Publish
        run: docker push ${{ env.CONTAINER_REGISTRY }}/${{ vars.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest

  deploy:
    runs-on: ubuntu-latest

    needs: docker

    steps:
      - name: Docker run
        run: docker run -d -p 8080:80 ${{ env.CONTAINER_REGISTRY }}/${{ vars.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest
```
