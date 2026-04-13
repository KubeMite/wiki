---
title: 'Jobs'
draft: false
weight: 4
series: ["Gitlab-CI"]
series_order: 4
---

The tasks in the CI/CD pipeline are configured as jobs
In Gitlab CI each pipeline one or more jobs, and each job runs in a seperate environment from any other job, and contains multiple steps

## Job syntax

```yaml
# The name of the job
run_tests:

  # Specifies which image the command will be run in
  # Always specify a tag so that the image version won't change without us knowing
  image: python:3.9-slim-buster

  # Commands that should run before the main script clause
  before_script:
    - apt-get update && apt-get install make

  # Used to specify what commands will run, must exist for job to be valid
  script:
    - make test
```

Job names are arbitrary, as long as they are don't contain key-words that GitLab pre-defined

Clause explanation:

- `image` - A job may contain an `image` clause, which will determine which image will be used to run the job steps inside of.
- `before_script` - A job may contain a `before_script` clause, which specifies one or more steps to run before the steps in the `script` clause
- `script` - A job must contain a `script` clause, which specifies one or more steps to run
- `after_script` - A job may contain an `after_script` clause, which specifies one or more steps to run after the steps in the `script` clause, even if the `script` clause failed

## Services in Jobs

We can use services to provide more capabilities to our job.
For example, a job to build a docker image inside of a docker executor:

```yaml
# The name of the job
build_image:

  # Variables will store values that can be reused in the pipeline
  variables:
    IMAGE_NAME: my-image/image
    IMAGE_TAG: python-app-1.0
    # In order for the docker client and daemon to communicate, they must share certificates. This insctructs the docker containers to share certificates in the same place.
    DOCKER_TLS_CERTDIR: "/certs"

  # We use dind (Docker in Docker) to build our image
  # This image will act as the docker client, and will use the docker daemon image to execute the commands
  image: docker:20.10.16

  # The docker daemon that the client will use
  services:
    - docker:20.10.6-dind

  # Commands that should run before the main script clause
  before_script:
    - docker login -u $REGISTRY_USER -p $REGISTRY_PASS

  # Used to specify what commands will run, must exist for job to be valid
  script:
    - docker build -t $IMAGE_NAME:$IMAGE_TAG .
    - docker push $IMAGE_NAME:$IMAGE_TAG
```

Since we are using the docker executer in the above example, we configure and use docker in docker (dind) to build and push our code

Clause explanation:

- `service` - an additional container(s) that will start at the same time as the job container. The job container will use the service container during the build time. All of the containers are linked together and can communicate with each other.

Other possible uses for the `service` clause:

- Python container that needs a mysql container to test database communication
