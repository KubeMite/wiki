---
title: 'Types of Runners'
draft: false
weight: 21
series: ["Github Actions"]
series_order: 21
---

Runners are virtual machines that are responsible for performing various tasks within a GitHub action workflow.\
A runner can handle tasks such as cloning a repository, installing software and executing commands.

## GitHub Hosted Runners

Each GitHub hosted runner is a fresh virtual machine that runs and hosted by GitHub. It comes pre-installed with various software and other tools, and comes with the option to choose from various operating systems, including Linux, Windows or MacOS.

GitHub hosted runners come in two types:

- **Standard Runner** - has limited resources in terms of ram, CPU and disk space. The default runner.
- **Larger Runner** - Has greater resources in terms of ram, CPU and disk space. Made for customers who are on GitHub teams and GitHub enterprise cloud accounts.

## Self-Hosted Runner

Self-hosted runners are machine that we manage and deploy ourself. This gives us more control over the hardware, operating system and software tools that our workflow runs on.\
Self-hosted runners can be run on any operating system, including custom operating systems as well.

Here are some reasons why we might choose to use the self-hosted runners:

- **Custom-execution environment:** Self-hosted runners allow us to create and maintain custom execution environments, which are tailored to our specific project requirements. This is especially useful if our project relies on specific software configuration, dependencies, or hardware that the GitHub hosted runners don't provide.
- **Controlled environment for security:** In some organizations strict security and compliance policy may prevent the use of GitHub hosted runners for certain workflows. In these instances, self-hosted runners can be set-up in a controlled environment that meets our organizations security and compliance requirements.
- **Eliminates wait time:** depending on the need for GitHub hosted runners in our organization, there might be wait time for available runners. Self-hosted runners eliminate this wait time as they are dedicated for our project
- **Scalability:** We can scale our self-hosted runner pool based on our projects needs. This can be particularly useful if we have many workflows or if we have multiple workflows in parallel, as GitHub hosted runners have predefined concurrency limits.
- **Reduced latency:** Self-hosted runners can be placed in specific geographic locations to reduce latency for our CI/CD workflows, especially if we have a global user base or need to comply with different data residency regulations.

While GitHub hosted runners are convenient and suitable for many use-cases, self hosted runner provide more control, flexibility and customization options.

## GitHub-Hosted Runner vs Self-Hosted Runner

| Aspect                | GitHub-Hosted Runner                              | Self-Hosted Runner                                     |
| --------------------- | ------------------------------------------------- | ------------------------------------------------------ |
| Managed By            | Managed by GitHub, fully maintained               | User/Owner managed and maintained                      |
| Customization         | Preconfigured environments, limited               | Fully customizable environments                        |
| Resource sharing      | Shared among all GitHub actions users             | Dedicated to a specific repository/org                 |
| Scaling               | Limited concurrency limits                        | Scalable to match project requirements                 |
| Maintenance           | GitHub handles updates and reliability            | User responsible for updates                           |
| Usage costs           | Free for public, charges for private              | Infrastructure and maintenance costs, no usage charges |
| Security & Compliance | GitHub-managed security policies                  | User-defined security and compliance                   |
| Instance              | Provides a clean instance for every job execution | Doesn't need to have a clean instance                  |
