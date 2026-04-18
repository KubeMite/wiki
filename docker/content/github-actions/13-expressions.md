---
title: 'Expressions'
draft: false
weight: 13
series: ["Github Actions"]
series_order: 13
---

Expressions are used to programmatically execute jobs and steps based on conditions.\
An expression can be a combination of any literal values, reference to a context or functions.

## The If Condition

The if condition controls whether a step of a job should proceed based on a defined condition.
The if condition is typically used within the configuration or a job or a step to determine its execution. If the condition or expression is true, the step or the job that the if condition is specified in will run.
Variables in an if expression don't need to be enclosed in `${{ }}`, they can be specified directly.

If condition in a job:

```yaml
jobs:
  <job_name>:
    if: <condition>
```

If condition in a step:

```yaml
jobs:
  <job_name>:
    steps:
      - name: <step_name>
        if: <condition>
```

Example:

```yaml
name: my-workflow

on:
  push:

env:
  CONTAINER_REGISTRY: docker.io
  IMAGE_NAME: my-image

jobs:
  docker:
    runs-on: ubuntu-latest

    steps:
      - name: Docker Build
        run: echo docker build -t $CONTAINER_REGISTRY/${{ vars.DOCKER_USERNAME }}/$IMAGE_NAME:latest

      - name: Docker Login
        run: echo docker login --username=${{ vars.DOCKER_USERNAME }} --password=${{ secrets.DOCKER_PASSWORD }}

      - name: Docker Publish
        run: echo docker push ${{ env.CONTAINER_REGISTRY }}/${{ vars.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest

  deploy:
    runs-on: ubuntu-latest

    needs: docker

    # Deploy step will only run if it is in main branch
    if: github.ref == 'refs/heads/main'

    steps:
      - name: Docker run
        run: |
          echo docker run -d -p 8080:80 ${{ env.CONTAINER_REGISTRY }}/${{ vars.DOCKER_USERNAME }}/${{ env.IMAGE_NAME }}:latest
          sleep 600s
```

## The Continue-On-Error Expression

The continue-on-error expression determines whether or not a job should continue running if a step fails.

By default, if a step fails the whole job will stop running. However, if continue-on-error is set to true, the job will continue running even if the step fails.

The continue-on-error option can be set on the job level or the step level:

- Job Level: continue-on-error will apply to all of the steps in the job.
- Step Level: continue-on-error will apply only to the specific step.

Continue-on-error should be used carefully, because it can lead to missed errors.

Continue-on-error in a job:

```yaml
jobs:
  <job_name>:
    continue-on-error: <condition>
```

Continue-on-error in a step:

```yaml
jobs:
  <job_name>:
    steps:
      - name: <step_name>
        continue-on-error: <condition>
```

Example:

```yaml
name: my-workflow

on:
  push:

jobs:
  testing:
    runs-on: ubuntu-latest

    steps:
      - name: Testing
        run: |
          export api_key=my-token
          echo "Running Tests..."

  reports:
    runs-on: ubuntu-latest

    needs: testing

    # Unsuccessful creation & upload of reports shouldn't block the rest of the workflow
    continue-on-error: true

    steps:
      - name: Upload report to AWS S3
        run: |
          echo "Uploading reports..."
          exit 1

  deploy:
    runs-on: ubuntu-latest

    needs: reports

    steps:
      - run: echo "Deploying..."
```

## Status Check Functions

Status check functions can be used to check the status of different aspects of a workflow, such as jobs, steps and functions.\
These function can help make decisions and control the flow of a workflow based on certain conditions.

Common status check functions:

- `success()` - Returns **true** if the status of a previous job or step is success, otherwise returns **false**.
- `failure()` - Returns **true** if the status of a previous job or step is failure, otherwise returns **false**.
- `cancelled()` - Returns **true** if the current job or step has been cancelled (due to manual intervention or any other reason), otherwise returns **false**.
- `always()` - Returns **true** regardless of the status of the previous or current job.

## If Expressions with Step Contexts

Step contexts provides a way to use the status of a step as a condition for another step using the if expression.

The full list of available step properties can be found [in this page](https://docs.github.com/en/actions/learn-github-actions/contexts#steps-context).

A step must have an id value set in order to access its step properties.\
Step properties can be accessed by `${{ steps.<step-id>.<property> }}` (as long as the requested step has a set id).

Syntax:

```yaml
jobs:
  <job-name>:
    steps:
      - name: <step-name-1>
        id: <step-id-1>
        run: <step-code-1>
      - name: <step-name-2>
        if: ${{ steps.<step-id-1>.<property> == <value> }}
        run: <step-code-2>
```

Example:

```yaml
name: my-workflow

on: push

jobs:
  randomly-failing-job:
    runs-on: ubuntu-latest
    steps:
      - name: Generate 0 or 1
        id: generate_number
        run: echo "random_number=$(($RANDOM % 2))" >> $GITHUB_OUTPUT
      - name: Pass or fail
        run: |
          if [[ ${{ steps.generate_number.outputs.random_number }} == 0 ]]; then exit 0; else exit 1; fi
```
