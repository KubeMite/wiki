---
title: 'Shell Commands and Scripts'
draft: false
weight: 2
series: ["Github Actions"]
series_order: 2
---

## Running a Shell Command

To run a shell command in a step, we can simply pass the command as the value to the `run` key of the step:

```yaml
- name: <step-name>
  run: <command>
```

For example:

```yaml
name: My workflow

on: push

jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:

    - name: Greeting
      run: echo hi
```

We can also pass multiple commands for a single step:

```yaml
- name: <step-name>
  run: |
    <command-1>
    <command-2>
    <command-3>
```

For example:

```yaml
name: My workflow

on: push

jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:

    - name: Count to 3
      run: |
        echo 1
        echo 2
        echo 3
```

## Running a Shell Script

If we have a shell script in our repo, we can run it from our workflow:

```yaml
# Clone the repo to the current directory
- name: Checkout Repo
  uses: actions/checkout@v4

- name: <step-name>
  run: ./<shell-script-location-in-repo>
```

For example:

```yaml
name: My workflow

on: push

jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:

    - name: Run shell script
      run: ./scripts/run.sh
```
