---
title: 'Workflow Context Information'
draft: false
weight: 11
series: ["Github Actions"]
series_order: 11
---

In Github Actions, a [context](https://docs.github.com/en/actions/learn-github-actions/contexts) is a set of predefined objects or variables that contain information about a workflow run.\
Context can contain information about environments, events, variables, runtime environments, secrets, jobs, steps, and various other options.\
Each context is an object that contains properties or some other object, which can be accessed within a workflow.

We can access a context using `${{ <context_name> }}`.

Possible context names are:

- `github`
- `env`
- `vars`
- `jobs`
- `steps`
- `runner`
- `secrets`
- `strategy`
- `matrix`
- `needs`
- `inputs`

We can access context properties using `${{ <context_name>.<property> }}` or `{{ <context_name>['<property>'] }}`.

Example workflow that prints most contexts:

```yaml
name: my-workflow

on: push

jobs:
  dump_contexts_to_log:
    runs-on: ubuntu-latest

    steps:
      - name: Dump GitHub context
        env:
          GITHUB_CONTEXT: ${{ toJson(github) }}
        run: echo "$GITHUB_CONTEXT"

      - name: Dump job context
        env:
          JOB_CONTEXT: ${{ toJson(job) }}
        run: echo "$JOB_CONTEXT"

      - name: Dump steps context
        env:
          STEPS_CONTEXT: ${{ toJson(steps) }}
        run: echo "$STEPS_CONTEXT"

      - name: Dump runner context
        env:
          RUNNER_CONTEXT: ${{ toJson(runner) }}
        run: echo "$RUNNER_CONTEXT"

      - name: Dump secret context
        env:
          SECRET_CONTEXT: ${{ toJson(secrets) }}
        run: echo "$SECRET_CONTEXT"
```
