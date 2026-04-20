---
title: 'Declarative Setup - Mono Application'
draft: false
weight: 12
series: ["Argo-CD"]
series_order: 12
---

We can create ArgoCD projects using manifests instead of using the web UI or the CLI.

Lets assume we have the following git repository:

```text
.
└── declarative
    ├── manifests
    │   └── application-model
    │       ├── deployment.yml
    │       └── service.yml
    └── mono-app
        └── application.yml
```

Inside of `./declarative/mono-app/application.yml` we have:

```yaml
apiVersion: argoproj.1o/v1alpha1
kind: Application
metadata:
  name: application-model-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/sidd-harth/test-cd.git
    targetRevision: HEAD
    path: ./declarative/manifests/application-model
destination:
  server: https://kubernetes.default.svc
  namespace: application-model
syncPolicy:
  syncOptions:
    - CreateNamespace=true
  automated:
    selfHeal: true
```

Now we can run `kubectl apply -f mono-app/application.yml` and the ArgoCD project will be created
