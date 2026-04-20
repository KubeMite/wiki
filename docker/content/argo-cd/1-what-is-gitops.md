---
title: 'What is GitOps'
draft: false
weight: 1
series: ["Argo-CD"]
series_order: 1
---

GitOps is a framework where the entire code delivery process is controlled via Git. This approach encompasses defining both infrastructure and applications as code, alongside the automation required to deploy changes and execute rollbacks. Essentially, GitOps is a specialized version of Infrastructure as Code (IaC) that utilizes Git as the primary control system.

The fundamental goal of GitOps is to ensure that the desired state stored within the Version Control System (VCS) and the actual live state in the production environment always match.

## The GitOps Workflow

In Kubernetes environments, the GitOps workflow revolves around a GitOps operator running inside the cluster.

- The operator continually monitors the designated Git repository and pulls any detected changes.
- It then applies these changes directly to the cluster it is running on, though it can also be configured to apply changes to external clusters.

### Application Code Deployment

When application code is updated, the deployment follows a specific sequence:

1. A Continuous Integration (CI) process tests the new changes, builds a fresh Docker image, and pushes that image to a container registry.
2. The CI process then updates the Kubernetes manifest in the repository to reference this new image tag.
3. The GitOps operator identifies the discrepancy between the repository and the live cluster, modifying the cluster to match the repository's updated state.

### Simplified Rollbacks

Because all infrastructure and application code is version-controlled in Git, GitOps greatly eases the rollback process. If a deployment fails, a simple `git revert` command can seamlessly undo all previous changes and restore the environment to a stable state.
