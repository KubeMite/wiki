---
title: 'Variables'
draft: false
weight: 3
series: ["Gitlab-CI"]
series_order: 3
---

Variables should be used to store sensitive values or any value that should not be defined in the pipeline configuration

## Declaring Variables

Variables that contain sensitive information should not be specified in the pipeline definition file, but in the repository itself:

To create a variable and set its value, follow these steps:

1. Hover over Setting and press **CI\CD**
2. Expand **Variables**
3. Add the variable name and value

## Using Variables in a Pipeline

To use a variable in a pipeline we need to reference the variables in the pipeline definition file.
Variables can also be created inside of the pipeline definition file.

```yaml
# The name of the job
build_image:

  # Variables can store values that will be reused in the pipeline
  variables:
    IMAGE_NAME: my-image/image
    IMAGE_TAG: python-app-1.0

  # Commands that should run before the main script clause
  before_script:
    - docker login -u $REGISTRY_USER -p $REGISTRY_PASS

  # Used to specify what commands will run, must exist for job to be valid
  script:
    - docker build -t $IMAGE_NAME:$IMAGE_TAG .
    - docker push $IMAGE_NAME:$IMAGE_TAG
```

Variables can be configured either on the job level or on the pipeline level. They will only apply to their scope.

The variables `$REGISTRY_USER` and `$REGISTRY_PASS` have been configured in the repository since they contain sensitive information.
