---
title: 'Application Resource'
draft: false
weight: 8
series: ["Argo-CD"]
series_order: 8
---

An Application is a custom resource definition which represents a deployed application instance in a cluster.\
An Application in ArgoCD is defined by two pieces of information: the source and the destination for the Kubernetes resources:

- **Source:** Mapped to a git repository where the desired state of the Kubernetes manifests live
- **Destination:** The target where the resources should be deployed in a Kubernetes cluster

Apart from the source and destination, and application also contains the project name it belong to along with the synchronization policies.

Instead of plain Kubernetes manifests as source, we can also have Helm charts, Kustomize, or Jsonnet.

An application can be created in multiple ways: CLI, YAML specification, Web UI.

```sh
argocd app create my-app \
--project default \
--sync-policy manual --sync-option CreateNamespace=true \
--repo https://github.com/my/repo.git --path my/application \
--dest-namespace my-namespace --dest-server https://kubernetes.default.svc
```

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
  namespace: argocd
spec:
  project: default
source:
  repoURL: https://github.com/my/repo.git
  targetRevision: HEAD
  path: my/application
destination:
  server: https://kubernetes.default.svc
  namespace: my-namespace
syncPolicy:
  automated:
    selfHeal: true
  syncOptions:
    - CreateNamespace=true
```

> By default ArgoCD does a pull request of the repo to see the changes it needs to apply every 3 minutes
