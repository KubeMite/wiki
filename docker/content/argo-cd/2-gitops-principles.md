---
title: 'GitOps Principles'
draft: false
weight: 2
series: ["Argo-CD"]
series_order: 2
---

GitOps relies on four foundational principles to maintain environmental consistency and reliability:

1. **Declarative vs. Imperative:** GitOps strictly demands that the entire state of the infrastructure is defined declaratively rather than imperatively.
2. **Use Git:** All declarative files representing the desired state must be stored in a Git repository. Git provides robust version control and enforces immutability across the environment.
3. **GitOps Operators:** Software operators are responsible for observing the version stored in Git. If the Git version does not match the current live state, the operator pulls the changes and applies them to the local cluster or other managed clusters.
4. **Reconciliation:** The GitOps operator ensures the entire system is self-healing, significantly reducing the risk of human error.

## The Reconciliation Loop

To achieve self-healing, the operator continuously loops through a three-step reconciliation process:

- **Observe:** Check the Git repository for any changes made to the desired state.
- **Diff:** Compare the desired state identified in the previous step against the current live state of the cluster.
- **Act:** Utilize a reconciliation function to alter the current state until it perfectly matches the desired state.
