---
title: 'Matrix'
draft: false
weight: 10
series: ["Github Actions"]
series_order: 10
---

There are cases where we want to run the same job with slight differences, for example when compiling the same code for multiple operating systems.\
In order to avoid repeating code unnecessarily, we can use [matrix strategies](https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs).

Matrix strategies let's us use a variable in a single job definition, which automatically creates multiple jobs that run in parallel based on the combination of all the variables we pass.

We define a matrix strategy under a certain job in the following way:

```yaml
jobs:
  <job_name>
    strategy:
      matrix:
        <key_1>: [<value_1>, <value_2>, <value_3>]
        <key_2>: [<value_4>, <value_5>, <value_6>]
```

In the jobs steps we access the matrix values in the job using `${{ matrix.<key> }}`.

For example, instead of using this workflow:

```yaml
name: my-workflow

on:
  push:

jobs:
  ubuntu-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Echo Docker Details
        run: docker info

      - name: Run Images
        run: docker run hello-world

  windows-deploy:
    runs-on: windows-latest

    steps:
      - name: Echo Docker Details
        run: docker info

      - name: Run Images
        run: docker run hello-world
```

We should use this workflow:

```yaml
name: my-workflow

on:
  push:

jobs:
  deploy:
    strategy:
      matrix:
        os: [ubuntu-latest, ubuntu-20.04, windows-latest]
        images: [hello-world, alpine]

    runs-on: ${{ matrix.os }}

    steps:
      - name: Echo Docker Details
        run: docker info

      - name: Run Image ${{ matrix.images }} on ${{ matrix.os }}
        run: docker run ${{ matrix.images }}
```

The above workflow will create 6 jobs running in parallel.

## Include and Exclude

We can add specific combinations that the matrix normally wouldn't run using the `include` keyword. We can even include new values that were not originally specified in the matrix.\
We can ensure that certain combinations of variables won't run in jobs by using the `exclude` keyword.

Syntax:

```yaml
jobs:
  <job-name>
    strategy:
      matrix:
        <key-1>: [<value-1>, <value-2>, <value-3>]
        <key-2>: [<value-4>, <value-5>, <value-6>]
      # Value-2 will never be paired together with value 5 in a matrix job
      exclude:
        - <key-1>: <value-2>
          <key-2>: <value-5>
      # New value (value-7) will be paired with value-5
      include:
        - <key-1>: <value-7>
          <key-2>: <value-5>
```

Example:

```yaml
name: my-workflow

on:
  push:

jobs:
  deploy:
    strategy:
      matrix:
        os: [ubuntu-latest, ubuntu-20.04, windows-latest]
        images: [hello-world, alpine]
        exclude:
          - images: alpine
            os: windows-latest
        include:
          - images: amd64/alpine
            os: ubuntu-20.04

    runs-on: ${{ matrix.os }}

    steps:
      - name: Echo Docker Details
        run: docker info

      - name: Run Image ${{ matrix.images }} on ${{ matrix.os }}
        run: docker run ${{ matrix.images }}
```

## Fail-Fast

The default behavior of matrix jobs is to fail all other jobs when any job in the matrix fails.\
By setting `fail-fast` to false, even if a matrix job fails the other jobs will not fail.

Syntax:

```yaml
jobs:
  <job-name>
    strategy:
      fail-fast: false
      matrix:
        <key-1>: [<value-1>, <value-2>, <value-3>]
        <key-2>: [<value-4>, <value-5>, <value-6>]
```

Example:

```yaml
name: my-workflow

on:
  push:

jobs:
  deploy:
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, ubuntu-20.04, windows-latest]
        images: [hello-world, alpine]

    runs-on: ${{ matrix.os }}

    steps:
      - name: Echo Docker Details
        run: docker info

      - name: Run Image ${{ matrix.images }} on ${{ matrix.os }}
        run: docker run ${{ matrix.images }}
```

## Max-Parallel

The default behavior of matrix jobs is to run all jobs in parallel.\
By setting `max-parallel` to a number, only that number of jobs will run in parallel while the rest will wait for one of the jobs to finish.

Syntax:

```yaml
jobs:
  <job-name>
    strategy:
      max-parallel: <number>
      matrix:
        <key-1>: [<value-1>, <value-2>, <value-3>]
        <key-2>: [<value-4>, <value-5>, <value-6>]
```

Example:

```yaml
name: my-workflow

on:
  push:

jobs:
  deploy:
    strategy:
      max-parallel: 2
      matrix:
        os: [ubuntu-latest, ubuntu-20.04, windows-latest]
        images: [hello-world, alpine]

    runs-on: ${{ matrix.os }}

    steps:
      - name: Echo Docker Details
        run: docker info

      - name: Run Image ${{ matrix.images }} on ${{ matrix.os }}
        run: docker run ${{ matrix.images }}
```
