---
title: 'Cache Dependencies'
draft: false
weight: 14
series: ["Github Actions"]
series_order: 14
---

Workflows can sometime require external dependencies. Instead of downloading them each time, we can cache them to increase workflow speed.\
We do that using the [cache action](https://github.com/actions/cache).

Syntax:

```yaml
jobs:
  <job-name>:
    steps:
      - name: <cache-step-name>
        uses: actions/cache@v3
        with:
          path: <dependency-path>
          key: <dependency-key>
```

- **dependency-path:** path to folder that stores the cached files.
- **dependency-key:** Key used to identify the cache. OS name and a hash of the dependency should be used so that it won't be used if the OS or dependency changes.

Example:

```yaml
name: my-workflow

on:
  push:
    branches:
      - main

jobs:
  unit-testing:
    name: Unit Testing

    strategy:
      matrix:
        nodejs-version: [18, 20]
        operating-system: [ubuntu-latest, macos-latest]

    runs-on: ${{ matrix.operating-system }}

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup NodeJS Version - ${{ matrix.nodejs-version }}
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.nodejs-version }}

      - name: Cache NPM dependencies
        uses: actions/cache@v3
        with:
          path: node_modules
          key: ${{ runner.os }}-node-modules-${{ hashFiles('package-lock.json') }}

      - name: Install Dependencies
        run: npm install

      - name: Unit Testing
        run: npm test

      - name: Archive Test Result
        uses: actions/upload-artifact@v3
        with:
          name: Mocha-Test-Result
          path: test-results.xml

  code_coverage:
    name: Code Coverage

    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Setup NodeJS Version - 18
        uses: actions/setup-node@v3
        with:
          node-version: 18

      - name: Cache NPM dependencies
        uses: actions/cache@v3
        with:
          path: node_modules
          key: ${{runner.os }}-node-modules-${{ hashFiles('package-lock.json') }}

      - name: Check Code Coverage
        continue-on-error: true
        run: npm run coverage

      - name: Archive Test Result
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: Mocha-Test-Result
          path: test-results.xml
```
