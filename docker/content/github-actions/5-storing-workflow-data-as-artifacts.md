---
title: 'Storing workflow data as artifacts'
draft: false
weight: 5
series: ["Github Actions"]
series_order: 5
---

We can use the [Upload a Build Artifact](https://github.com/marketplace/actions/upload-a-build-artifact) and the [Download a Build Artifact](https://github.com/marketplace/actions/download-a-build-artifact) to move files between jobs in a workflow.

```yaml
name: move-files-job

on: push

jobs:
  job-1:
    runs-on: ubuntu-latest
    steps:
    - name: Greeting
      run: echo hi > hi.txt

    - name: Upload dragon text file
      uses: actions/upload-artifact@v3
      with:
        name: hi-file
        path: hi.txt

  job-2:
    needs: job-1
    runs-on: ubuntu-latest
    steps:
      - name: Download greeting
        uses: actions/download-artifact@v3
        with:
          name: hi-file

      - name: Output greeting file content
        run: cat hi.txt
```

Uploaded files will be stored for 90 days by default. This can be changed in settings.
