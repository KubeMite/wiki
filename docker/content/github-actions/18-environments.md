---
title: 'Environments'
draft: false
weight: 18
series: ["Github Actions"]
series_order: 18
---

Environments are used to isolate different stages of the development process, such as development, testing and production. This allows developers to work on new features without effecting existing users, and also allows QA testers to verify that new features work correctly before they are deployed to production.\
In GitHub actions, environments are a powerful feature that can help us organize, protect and visualize our deployment.

## Secrets

One major feature of environments is to store secrets and variables that are specific to a particular environment. This allows us to keep secrets out of workflow files and make them easier to manage.

GitHub Actions provides two ways to store secrets: repository secrets and environment secrets.\
There are major differences between repository secrets and environment secrets:

- **Scope:** repository secrets are specific to a single repository, while environment secrets are specific to a particular environment. This means that environment secrets can be used in workflows that run in different repositories as long as they're referring to the same environment.
- **Visibility:** repository secrets are visible to all users who have access to the repository, whereas environment secrets can be made private so that they are only visible to users who have access to the environment.
- **Accessibility:** Repository secrets are accessible to all the jobs that run in the workflow, whereas environment secrets are only accessible to jobs that are running in that specific environment.
- **Precedents:** If a secret exists in both the repository and the environment level, the environment level secret takes a higher precedent.

## Deployment Protection Rules

In addition to secret storage, environments also provide deployment protection rules, which provides a way to control who can deploy changes to an environment. They can be used to add manual approvals, delay a deployment, or restrict deployments to certain branches or users.

Environments can be created by accessing the settings tab within a GitHub repository, where we can specify deployment protection rules:

- **Required reviewers:** up to 6 people can be specified. Any one of the 6 must manually approve a job in order for it to proceed. This prevents unauthorized changes from being deployed to production or any other environment.
- **Wait timer:** an amount of time to wait before a deployment may proceed. This gives an opportunity to review the modifications before they go live in the production environment.
- **Deployment branch rules:** allows us to restrict deployments to a particular branch. For example, this allows us to ensure that deployments will only run from the main branch.

## Set Environment Tag for a Job

In order for a job to use a specific environment, the `environment` key under the job name should be used (assuming the environment was already created):

```yaml
name: my-workflow

on: push

jobs:
  <job_name>:
    environment:
      name: <environment-name>
      url: <url>
```

The `url` field can be used to display the url of the application in the ui and the logs (if applicable for the application). \
This can help managers review deployment logs for reviewing or debugging, and can help developers easily check if the application is accessible in the url.
