---
title: 'Push vs Pull Based Deployments'
draft: false
weight: 3
series: ["Argo-CD"]
series_order: 3
---

When delivering applications to a Kubernetes cluster, organizations generally use one of two architectures: Push-based or Pull-based.

| Feature | Push-Based Approach | Pull-Based Approach (GitOps) |
| --- | --- | --- |
| **Mechanism** | Changes go through a CI/CD pipeline and are explicitly pushed into the Kubernetes cluster. | A GitOps operator running inside the cluster pulls changes by checking a Git or container repository. |
| **Pipeline Access** | The CI/CD system requires Read/Write access to the container registry to push Docker images. | The CI/CD system requires Read/Write access to the container registry, but **does not** have access to the cluster. |
| **Cluster Security** | The CI/CD system needs Read/Write permissions to the cluster, meaning the cluster must be exposed to the outside. This is not recommended. | Highly secure. The cluster does not need to be exposed externally, as the operator works from the inside out. |
| **System Coupling** | The deployment approach is heavily coupled to the Continuous Delivery (CD) system since the deployment executes on the pipeline. | The deployment approach is completely decoupled from the CD system since the deployment executes directly on the cluster. |
| **Multi-Tenancy** | Traditionally difficult to manage across multiple distinct tenants safely. | GitOps operators natively support a multi-tenant model. |
| **Secret Management** | Easier to manage. Secrets can be dynamically injected during the pipeline deployment process. | Harder to manage. Secrets must be encrypted or stored as references within the Git repository. |

> **Note on traditional tooling:** Most legacy deployment tools are strictly push-based, utilizing standard CI/CD pipelines.
