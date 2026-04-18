---
title: 'Passing data between jobs'
draft: false
weight: 17
series: ["Github Actions"]
series_order: 17
---

Data can be passed between jobs using key-value pairs.

This can be useful for cases when one jobs need data that is created in another job.\
For example, defining a url to curl for integration testing when the url is defined by a kubernetes ingress that is created in an earlier job.

Example:

```yaml
name: my-workflow

on: push

jobs:
  job1:
    runs-on: ubuntu-latest

    # Map a step output to a job output
    outputs:
      output1: ${{ steps.step1.outputs.test }}
      output2: ${{ steps.step2.outputs.test }}

    steps:
      - id: step1
        run: echo "test=hello" >> "$GITHUB_OUTPUT"
      - id: step2
        run: echo "test=world" >> "$GITHUB_OUTPUT"

  job2:
    runs-on: ubuntu-latest

    needs: job1

    steps:
      - env:
          OUTPUT1: ${{needs.job1.outputs.output1}}
          OUTPUT2: ${{needs.job1.outputs.output2}}
        run: echo "$OUTPUT1 $OUTPUT2"
```

Explanation:

First we specify the outputs of the job (job1) in the job level. We will use the outputs as a way to access the same values from different jobs.

We specify which value we want to store by using `steps.<step_id>.outputs.<key>`

```yaml
jobs:
  job1:
    runs-on: ubuntu-latest

    # Map a step output to a job output
    outputs:
      output1: ${{ steps.step1.outputs.test }}
      output2: ${{ steps.step2.outputs.test }}
```

We then generate and save the values in the first job.\
We store key-value pairs in the `GITHUB_OUTPUT` environment variable.

```yaml
steps:
  - id: step1
    run: echo "test=hello" >> "$GITHUB_OUTPUT"

  - id: step2
    run: echo "test=world" >> "$GITHUB_OUTPUT"
```

In the second job we can access the data we created in the first job.\
We do that by using `<env_name>: ${{ needs.<job_name>.outputs.<output_name> }}` where `job_name` is the job where we first initialized the values, and `env_name` is the environment variable which we will put the value in.

```yaml
job2:
  runs-on: ubuntu-latest

  needs: job1

  steps:
    - env:
        OUTPUT1: ${{needs.job1.outputs.output1}}
        OUTPUT2: ${{needs.job1.outputs.output2}}
      run: echo "$OUTPUT1 $OUTPUT2"
```

The final output for the full workflow will be `hello world`.
