---
title: 'CI/CD with GitOps'
draft: false
weight: 19
series: ["Argo-CD"]
series_order: 19
---

In GitOps, we are going to make use of 2 Git repositories:

- Application code repository
- Kubernetes manifests repository

The GitOps operator (ArgoCD), which is running within a Kubernetes cluster, is going to pull manifests from the Kubernetes manifests repository.\
When developers push a change in the application code repository, a CI pipeline will trigger which will run the following steps:

1. Unit test
1. Build artifacts
1. Build docker images
1. Push docker images to a container registry
1. Clone the Kubernetes manifests repository
1. Update image version in the Kubernetes manifests repository
1. Push the change to a feature branch
1. Open a PR to merge the changes from the feature branch to the main branch on the Kubernetes manifests repository

Now a project manager or an architect is going to accept or reject the PR.\
Once the PR is accepted, the new changes will be merged to the main branch of the Kubernetes manifests repository and the GitOps operator will apply the changes.

> **What if the new image has an issue and we need to roll back?**\
An argoCD admin or developer can quickly check the application history in the ArgoCD CLI or Web UI, and rollback the changes.

{{< mermaid >}}
graph TD
subgraph Dev [" "]
    Developer((Developer))
end

subgraph AppRepo ["Application Code Repository"]
    GitApp[Git Repo<br/>Python, Docker, etc.]
end

Developer -- "push / merge" --> GitApp

subgraph CI ["Continuous Integration"]
    direction TB
    Test[unit test] --> BuildArt[build artifact]
    BuildArt --> BuildImg[build image]
    BuildImg --> PushReg[push registry]
    PushReg --> CloneMan[clone manifest config repo]
    CloneMan --> UpdateMan[update manifests v6.7]
    UpdateMan --> PushFeat[push to feature branch]
    PushFeat --> OpenPR[open PR]
end

GitApp --> CI

subgraph DesiredState ["Kubernetes Manifests Repository (Desired State)"]
    GitManifest[Git Repo<br/>Helm, YAML]
end

OpenPR --> GitManifest
SRE((Reviewer)) -- "approve & merge PR" --> GitManifest

subgraph Cluster ["prod-cluster (Actual State)"]
    Argo[ArgoCD Operator]
    Pod((POD))
    Svc((SVC))

    Argo --- Pod
    Argo --- Svc
end

GitManifest -. "PULL manifests / Synchronize" .-> Argo

Operator((Operator)) -- "argocd app history / rollback" --> Argo

%% Styling
style CI fill:#f3e5f5,stroke:#9c27b0,stroke-dasharray: 5 5
style Argo fill:#2ecc71,stroke:#27ae60,color:#fff
style Pod fill:#3f51b5,stroke:#1a237e,color:#fff
style Svc fill:#3f51b5,stroke:#1a237e,color:#fff
style DesiredState fill:#fff,stroke:#333
style Cluster fill:#fff,stroke:#333
{{< /mermaid >}}
