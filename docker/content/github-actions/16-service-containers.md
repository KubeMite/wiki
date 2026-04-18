---
title: 'Service Containers'
draft: false
weight: 16
series: ["Github Actions"]
series_order: 16
---

Service containers provide a simple and portable way to host services required to test applications in a workflow.

For example, a workflow might require executing unit tests that depend on a database and some memory cache.

Additionally, we can configure various settings such as the environment variables to be set and the ports to be exposed.

To use a service container, we must specify the docker image by utilizing the service tag in a workflow file.

```yaml
name: my-workflow

on: push

jobs:
  unit-testing:
    runs-on: ubuntu-latest

    services:
      mongodb-service:

    image: mongo-db
      ports:
        - 12345:27017

    steps:
      - name: Checkout Code
      - name: Install NodeJS Version 20
      - name: Install Dependencies
      - name: Install Testing Packages
      - name: Run Tests
        run: npm test
      env:
      MONGODB_HOST: localhost
      MONGODB_PORT: 12345
```

This will allow our workflow to connect to the service container in `localhost:12345`.
