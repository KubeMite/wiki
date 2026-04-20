---
title: 'Types of Sync Strategies'
draft: false
weight: 11
series: ["Argo-CD"]
series_order: 11
---

ArgoCD allows customization for how it synchronizes the desired Git state to the target Kubernetes cluster.

## Sync Types

When ArgoCD discovers a new version of the application in Git, it either performs a manual sync or an automated sync.

- **Automatic:** ArgoCD will apply the changes then update or create new resources in the target Kubernetes cluster
- **Manual:** ArgoCD will detect the changes but won't apply them to the target Kubernetes cluster until and unless a user manually synchronizes the change using the web UI or the CLI

## Auto-Pruning

The auto-pruning feature describes what happens when files are deleted or removed from Git.

- **Enabled:** ArgoCD will delete the corresponding resources from the cluster
- **Disabled:** ArgoCD won't delete the corresponding resources from the cluster

## Self Healing

Self-healing defines what ArgoCD does when anyone makes changes to the cluster manually using kubectl.

- **Enabled:** ArgoCD will revert manual changes done to the cluster. This option should be chosen if you with to adhere to the GitOps standard
- **Disabled:** ArgoCD will not revert manual changes done to the cluster
