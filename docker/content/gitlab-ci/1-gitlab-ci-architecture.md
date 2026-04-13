---
title: 'Gitlab CI Architecture'
draft: false
weight: 1
series: ["Gitlab-CI"]
series_order: 1
---

Gitlab-CI is a system to run CI pipelines for code stored in a Gitlab instance.

Gitlab-CI requires two components: the Gitlab instance and Gitlab runners

## Gitlab Instance

- Hosts application code and pipeline configuration
- Manages the pipeline execution

## Gitlab Runners

- Separate machines which are connected to the GitLab server instance
- Agents that run CI/CD jobs
- Gitlab server assigns pipeline jobs to available runners
- Different types of runners exist, with different executors. The executors determines the environment each job runs in:
  - Shell executor
    - the simplest executer
    - Commands executed directly on operating system
  - Docker executer
    - Command are executed inside a container
    - Only docker itself needs to be installed on the host machine
    - Each job runs in a separate & isolated container

## Gitlab.com

[Gitlab.com](http://gitlab.com) is a managed GitLab instance that offers multiple managed runners out of the box which are maintained by GitLab

Each runner on [gitlab.com](http://gitlab.com) uses the Docker executer

By default, runners managed by GitLab use a ruby image to start the container, but that can be overwritten in the pipeline configuration
