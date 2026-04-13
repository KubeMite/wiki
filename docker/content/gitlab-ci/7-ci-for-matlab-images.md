---
title: 'CI For Matlab Images'
draft: false
weight: 7
series: ["Gitlab-CI"]
series_order: 7
---

This tutorial shows how to compile Matlab code to a Docker image using GitLab CI.
This tutorial assumes Matlab version R2022b.
This tutorial has been tested on GitLab version 11.8.0.
The CI compiles the Matlab code to a standalone file, then copies the file into a Docker image with Matlab runtime installed.

Requirements:

- Matlab license server with a license to compile toolbox.
- GitLab runner installed on a server as Docker executor.

Steps:

1. Configure a GitLab runner using the following guide: [Installing GitLab Runner as Docker Executor](6-installing-gitLab-runner-as-docker-executor) and add the following flag to the Docker registration command: `--docker-volumes "/builds:/builds"`

2. The following `.gitlab-ci.yml` file to specify the CI steps:

```yaml
variables:
  MATLAB_LICENSE_PORT: <license-server-port>
  MATLAB LICENSE_SERVER: <license-server-hostname>
  DOCKER_IMAGE_NAME: <docker-repo-name>/${CI_PROJECT_NAME}/${CI_COMMIT_REF_NAME}:${CI_COMMIT_SHA}
  BUILD_PATH: /builds/${CI_PROJECT_NAME}/${CI_COMMIT_REF_NAME}/${CI_COMMIT_SHA}

stages:
  - build

build_image:
  stage: build
  image:
  name: docker:<docker-engine-version>

  before_script:
  - mkdir -p ${BUILD_PATH}
  - chmod 777 ${BUILD_PATH}

  script:
  # Compile Matlab code to a standalone application
  - docker run -v ${CI_PROJECT_DIR}:/home/matlab/Documents/MATLAB -v ${BUILD_PATH}:/home/matlab --rm -e MLM_LICENSE_FILE=${MATLAB_LICENSE_PORT}@${MATLAB_LICENSE_SERVER} <matlab-image-with-compile-toolbox> -batch "compiler.build.standaloneApplication('<main-file>', 'AdditionalFiles', '.', 'OutputDir', '/home/matlab', 'ExecutableName', 'app')"

  - cd ${BUILD_PATH}

  # Create .dockerignore that ignores .matlab folder in build path
  - |
    cat << EOT > .dockerignore
    .matlab/
    EOT

  # Create dockerfile that runs Matlab standalone application
  - |
    cat << EOT > Dockerfile
    FROM demartis/matlab-runtime:R2022b
    COPY . /app
    ENTRYPOINT ["/app/app"]
    EOT

  # Create docker image that runs Matlab standalone application
  - docker build . -t ${DOCKER_IMAGE_NAME}
  - docker push ${DOCKER_IMAGE_NAME}

  after_script:
  - rm -rf ${BUILD_PATH}
  - docker image rm ${DOCKER_IMAGE_NAME}
```

Build stages explained:

1. Create a folder on the host that will store the Matlab standalone application.
2. Give general permissions to the folder so that the Matlab user can access it to store the standalone application.
3. Use a Matlab docker image to compile the code into a standalone application.
4. Create a `.dockerignore` file in the standalone application folder to not compile the `.matlab` folder into the Docker image.
5. Create the Docker file that will be used to build the Docker image.
6. Create and tag the Docker image.
7. Push the Docker image.
8. Delete the standalone application from the local server.
9. Delete the Docker image locally.

Downsides:

- No isolation between the container that creates the standalone application to the host since we are writing the standalone application to the host.
- No isolation between the container that creates the Matlab docker image to the host since we are mounting the Docker socket from the host to the Docker container (I tried [Kaniko](https://github.com/GoogleContainerTools/kaniko), it doesn't work for Matlab).
- The current CI/CD can't run on Kubernetes since we write the information to the host and use the host Docker socket. (Maybe with some alteration the CI/CD can work on Kubernetes and use the local node container runtime socket).
