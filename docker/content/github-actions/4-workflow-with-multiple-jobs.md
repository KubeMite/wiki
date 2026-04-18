---
title: 'Workflow with Multiple Jobs'
draft: false
weight: 4
series: ["Github Actions"]
series_order: 4
---

Each job runs in it's own environment. No data is shared between jobs.\
When multiple jobs are specified in a workflow, they will run in parallel by default.

Example workflow with multiple jobs:

```yaml
name: my-job

on: push

jobs:
  job-1:
    runs-on: ubuntu-latest
    steps:
    - name: Greeting
      run: echo hi

  job-2:
    runs-on: ubuntu-latest
    steps:
      - name: parallel
        run: echo hello
```

Both of the above jobs will run in parallel.

## Needs

If we want to declare order in which jobs will run and transfer data between them, we can use the *needs* syntax.\
The *needs* keyword can be set in a job to specify which jobs must succeed in order for the job to start running.\
It is a great way to define dependencies between jobs, e.g. only run the build job once the tests job passes.

Example workflow with multiple jobs running consecutively:

```yaml
name: my-job

on: push

jobs:
  test-job:
    runs-on: ubuntu-latest

    steps:
    - name: Run tests
      run: echo testing...

  build-job:
    needs: test-job
    runs-on: ubuntu-latest

    steps:
      - name: Run builds
        run: echo building...
```

- If a job should to be dependent on the success of multiple jobs, we can specify an array of jobs under the *needs* keyword.
- If a job fails, the jobs dependent on it will fail.
