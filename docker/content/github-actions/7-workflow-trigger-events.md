---
title: 'Workflow Trigger Events'
draft: false
weight: 7
series: ["Github Actions"]
series_order: 7
---

Many events can trigger a workflow, such as:

- Push
- Pull request
- Cron job
- Outside event
- Manual

For all of the events see [this list](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows).

All events are set using the `on` keyword in a workflow, like so:

```yaml
on: <event>
```

## Examples

For example, a schedule event:

We can specify a cron job to trigger a workflow:

```yaml
on:
  schedule:
    - cron: "*/1 * * * *"
```

Workflows ran using this trigger will show that they were triggered by a cron job.

For example, a Workflow Dispatch event:

We can specify to only run the workflow on a manual deployment:

```yaml
on:
  workflow_dispatch:
```

## Event Filters

Event filters allow us to target specific branches for certain events

For example, we can specify that we will run a workflow only if there is a push to certain branches:

```yaml
on:
  push:
    branches:
      - 'main' # Will only run on pushes to main
      - 'feature/*' # Will only run on branches starting with "feature/" one level deep: feature/add-music, feature/update-images
      - 'test/**' # Will only run on branches starting with "test/" any level deep: test/ui, test/checkout/payment
```

## Activity Types

Activity types provide more granular control over what triggers a workflow.\
For example, the `pull_request` event can be triggered when a pull request is opened, edited, or closed. We can use the `types` keyword to specify which of these activities (like opening a pull request) will cause the workflow to run.

Example of a workflow that will only run only if there is a pull request that has been reopened:

```yaml
on:
  pull_request:
    types:
      - reopened
```

## Multiple Event Filters and Activity Types

There are situation where we need to specify multiple event filters and activity types for the same trigger event. In that case, all of the event filters and activity types must be satisfied before the trigger event will trigger a new workflow.

For the workflow below, a pull request must be of either opened or closed type, must have a change that doesn't concern `README.md` file, and must target the main branch.

```yaml
on:
  pull_request:
    types:
      - opened
      - closed
    paths-ignore:
      - README.md
    branches:
      - main
```

If one of the conditions isn't satisfied, the workflow will not run.
