---
title: 'Reusable Workflows'
draft: false
weight: 19
series: ["Github Actions"]
series_order: 19
---

Multiple teams may need to share workflows, for example when each team uses a different programming language but the deployment workflow is the same. For that reason we have reusable workflows.

The used workflow is called a **called workflow**, while the workflow that calls the reusable workflow is called the **caller workflow**

## Setting Up a Reusable Workflow

For a workflow to be reusable, it must include the value `workflow_call:` under the `on:` key.\
Reusable workflows can also contain inputs, outputs and secrets in order to pass data between workflows.

```yaml
name: My Reusable Workflow

on:
  workflow_call:
    inputs:
      <input-name>:
        # Is the input required?
        required: <true|false>
        # Input description, optional
        description: <secret-description>
        # Input type
        type: <variable-type>
    outputs:
      <output-name>:
        value: <output-value>
    secrets:
      <secret-name>:
      # Is the value required?
        required: <true|false>
        # secret description, optional
        description: <secret-description>
```

- **input-name:** specifies the name of the input key that will store the input value, and will be accessible under `${{ inputs.<variable-name> }}` from inside the reusable workflow.
- **secret-name:** specifies the name of the secret key that will store the secret value, and will be accessible under `${{ secrets.<secret-name> }}` from inside the reusable workflow.
- **output-name:** specifies the name of the output key that will store the output value, and will be accessible under `${{ needs.<job-name-that-called-reusable-workflow>.outputs.output-name }}` from the workflow that called the reusable workflow.

## Using a Reusable Workflow

In order to use a reusable workflow, we must specify the path to it and optionally pass values to it

```yaml
name: My Workflow

on:
  push

jobs:
  unit-testing:
    ...
  code-coverage:
    ...
  build:
    ...
  dev-deploy:
    needs: [build]
    uses: <path-to-reusable-workflow>
    with:
      <input-name>: <input-value>
    secrets:
      <secret-name>: <secret-value>
```

- **path-to-reusable-workflow:** depends on the location of the reusable workflow file.
  - If it is in the same repo we can use `./.github/workflows/reusable-workflow.yml`.
  - If it is in a different organization we can use `<organization-name>/<repo-name>/.github/workflows/reusable-workflow.yml@<ref>`. ref can be a branch name, a tag or a commit sha.
- **input-name:** the name of the input as specified in the reusable workflow file
- **input-value:** the input value we want to pass to the reusable workflow file.
- **secret-name:** the name of the secret as specified in the reusable workflow file
- **secret-value:** the secret value we want to pass to the reusable workflow file.
