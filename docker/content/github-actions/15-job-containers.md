---
title: 'Job Containers'
draft: false
weight: 15
series: ["Github Actions"]
series_order: 15
---

A job container in GitHub actions is a docker container that is used to run steps in a job.

Job containers provide a couple of benefits, such as isolation, reproducibility and security.\
Each job runs in its own container, which isolates it from other jobs and the host machine. This helps to prevent conflicts and security bridges.\
Job containers can be set to use a specific set of permissions, which helps to protect the host machine from malicious code.

Each job container can be used to run the job on any machine, which ensures that the results of the job are reproducible.

Example:

To utilize a job container in a workflow, we must specify the docker image to be used within the job:

```yaml
name: my-workflow

on: push

jobs:
  unit-testing:

    runs-on: ubuntu-latest

    container:
      image: ghcr.io/node-and-packages:20

      credentials:
        username: alice
        password: ${{ secrets.pwd }}

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      # Not needed - done in job container
      # - name: Install NodeJS Version 20

      - name: Install Dependencies
        run: npm install

      # Not needed - done in job container
      # - name: Install Testing Packages

      - name: Run Tests
        run: npm test
```

In the above workflow, NodeJS and testing packages are installed in the container image, saving workflow time.

The entire `unit-testing` job runs inside of the job container.
