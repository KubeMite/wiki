---
title: 'Stages'
draft: false
weight: 5
series: ["Gitlab-CI"]
series_order: 5
---

We may want jobs to run after each other, and not all simultaneously. For that reason, we can use stages.
Stages allow us to set the order in which our jobs will run.

Example pipeline configuration file with stages:

```yaml
# Sets in which order the jobs will run. All jobs in a stage must finish for the next stage to begin
stages:
  - test
  - build
  - deploy

# Variables will store values that can be reused in the pipeline
variables:
  IMAGE_NAME: my-image/image
  IMAGE_TAG: python-app-1.0

# The name of the job
run_tests:

  # Defines which stage this job is a part of
  stage: test

  # Specifies which image the command will be run in
  # Always specify a tag so that the image version won't change without us knowing
  image: python:3.9-slim-buster

  # Commands that should run before the main script clause
  before_script:
    - apt-get update && apt-get install make

  # Used to specify what commands will run, must exist for job to be valid
  script:
    - make test

# The name of the job
build_image:

  # Defines which stage this job is a part of
  stage: build

  # Variables will store values that can be reused in the pipeline
  variables:
    # In order for the docker client and daemon to communicate, they must share certificates. This instructs the docker containers to share certificates in the same place.
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

# The name of the job
deploy:

  # Defines which stage this job is a part of
  stage: deploy

  # Ensures only we can access the ssh key, otherwise the key will be considered insecure and ssh will not work
  before_script:
    - chmod 400 $SSH_KEY

  # Used to specify what commands will run, must exist for job to be valid
  script:
    # We ssh into our deployment machine. All commands will be run there.
    - ssh -o StrictKeyChecking=no -i $SSH_KEY root@123.123.123.123 "
        # We login into our private registry
        docker login -u $REGISTRY_USER -p $REGISTRY_PASS &&
        # We stop all running containers
        docker ps -aq | xargs docker stop | xargs docker rm &&
        # Deploy our container
        docker run -d -p 5000:5000 $IMAGE_NAME:$IMAGE_TAG
    "
```
