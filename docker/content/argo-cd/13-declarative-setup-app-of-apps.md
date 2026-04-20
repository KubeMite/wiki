---
title: 'Declarative Setup - App of Apps'
draft: false
weight: 13
series: ["Argo-CD"]
series_order: 13
---

Instead of deploying each application manually, ArgoCD's App of Apps pattern enables us to programmatically and automatically generate ArgoCD applications.

We can create a root ArgoCD application using the App of Apps pattern.\
The root ArgoCD application points to a folder that includes the ArgoCD application YAML definition files for each microservice or application.\
The application YAMLs for each microservice refers to a directory holding the application manifests.

The idea is to create a single ArgoCD application and upload all of its definition files into a Git repository path.

Lets assume we have the following git repository:

```text
.
└── declarative
    ├── app-of-apps
    │   ├── triangle-app.yml
    │   ├── diamond-app.yml
    │   └── hexagon-app.yml
    ├── manifests
    │   ├── triangle
    │   │   ├── deployment.yml
    │   │   └── service.yml
    │   ├── diamond-model
    │   │   ├── deployment.yml
    │   │   └── service.yml
    │   └── hexagon
    │       ├── deployment.yml
    │       └── service.yml
    ├── mono-app
    │   └── diamond-app.yml
    └── multi-app
        └── app-of-apps.yml
```

The root ArgoCD application is `./declarative/multi-app/app-of-apps.yml`, and it contains:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-of-apps
spec:
  project: default
  source:
    repoURL: https://github.com/sidd-harth/test-cd.git
    targetRevision: HEAD
    path: ./declarative/app-of-apps
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

The `path` refers to the directory containing our three applications, which ensures that ArgoCD will create and manage them.

The `./declarative/app-of-apps/triangle-app.yml` contains the triangle-app itself:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: triangle-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/sidd-harth/test-cd.git
    targetRevision: HEAD
    path: ./declarative/manifests/triangle
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

This time the `path` refers to the directory containing the manifests of the triangle app, which ensures that ArgoCD will create and manage them.

The same concept can be used to manage any Kubernetes object and even ArgoCD itself.
Whenever an application definition is updated or created in this Git repo path, an ArgoCD application will be updated or automatically created
