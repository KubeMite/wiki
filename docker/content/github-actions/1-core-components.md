---
title: 'Core Components'
draft: false
weight: 1
series: ["Github Actions"]
series_order: 1
---

Github Actions consists of three core components: workflow, jobs and steps.\
Those components must be in the correct file structure.

Example workflow file:

```yaml
name: My Awesome App
on: push
jobs:
  unit-testing:
    name: Unit Testing
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Install NodeJS
        uses: actions/setup-node@v3
        with:
          node-version: 20
      - name: Install Dependencies
        run: npm install
      - name: Run Unit Tests
        run: npm test
```

## File Structure

All workflow files must be in a Github repository in `.github/workflows/<workflow_file>.yaml`.\
Each file in the `workflows` folder is an individual workflow.\
A workflows will run when its trigger is activated (unless manually deactivated).\
Multiple workflows can run for the same commit simultaneously.

## Workflow

- An automated process capable of executing one or more jobs.
- Widely used in building and testing code to deploy to various environments.
- Workflows are defined using YAML files and are located within a repository.
- A repository can have multiple workflows, each of which runs in response to a specific event occurring in your repository.
- To identify workflows, each workflow can have an optional name keyword. This name will be visible in the actions tab of the Github repository.

## Job

- The building blocks of a workflow.
- There can be one or more jobs within a single workflow.
- Each job is associated with a runner (Github hosted or self hosted) which we specify in the `runs-on` attribute.
- Every job is separate from any other job and runs in its own environment. No data may be shared between different jobs.

## Step

- Steps are individual tasks that make up a job.
- They are executed sequentially within a jobs runner environment.
- Steps can include commands, actions, or scripts, allowing to automate building, testing, or deploying code as part of the CI/CD process.

## Actions

- Actions within Github workflows are prebuilt reusable automation components designed for a specific task.
- Each action can be created by you or a member of the community, making it easy to share and reuse automation logic within the repositories.
- Actions can facilitate integrations with third party tools and services, therefore enhancing your projects automation capabilities.
- Examples of actions:
  - Build and push docker images.
  - Create AKS cluster.
  - Consume vault secrets.
