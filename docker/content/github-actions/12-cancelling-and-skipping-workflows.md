---
title: 'Cancelling and Skipping Workflows'
draft: false
weight: 12
series: ["Github Actions"]
series_order: 12
---

When making a change, we may not want it to trigger a workflow. In that case, we can specify that we want to [skip a workflow run](https://docs.github.com/en/actions/managing-workflow-runs/skipping-workflow-runs).

## Skipping Workflows

Skipping a workflow run can be done for *push* and *pull request* events by including the following string in the commit message in a push, or the HEAD commit of a pull request (square brackets must also be in the string):

- `[skip ci]`
- `[ci skip]`
- `[no ci]`
- `[skip actions]`
- `[actions skip]`

We can also skip a workflow by ending a commit message with two empty lines and then the following string:

- `skip-checks:true`
- `skip-checks: true`

## Cancelling a Running Workflow

We can also cancel a running workflow by using the UI `cancel workflow` button while the workflow is running.
