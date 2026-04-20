---
title: 'Deploy apps using Helm Chart'
draft: false
weight: 14
series: ["Argo-CD"]
series_order: 14
---

Helm is a package manager for Kubernetes.\
Helm charts enable declarative application definitions, which is a fundamental part of GitOps.\
Helm uses a repository service to store the Helm charts.\
ArgoCD can deploy Helm charts and monitor them for new changes or versions.

> The following deployment examples are done using the CLI, but they can also be done using the web UI.

Lets assume we have the following Git repository structure:

```text
.
└── helm-chart
    ├── Chart.yaml
    ├── templates
    │   ├── NOTES.txt
    │   ├── _helpers.tpl
    │   ├── configmap.yaml
    │   ├── deployment.yaml
    │   └── service.yaml
    └── values.yaml
```

Using ArgoCD CLI, we can create an application and deploy the Helm chart by using the following CLI command:

```sh
argocd app create random-shapes \
  --repo https://github.com/my/repo.git \
  --path helm-chart \
  --helm-set replicaCount=2 \
  --helm-set my.color=yellow \
  --helm-set service.type=NodePort \
  --dest-namespace default \
  --dest-server https://kubernetes.default.svc
```

ArgoCD can also deploy Helm charts from Helm repositories (not just from Git repositories that contain Helm charts):

```sh
argocd app create my-app \
  --repo https://charts.bitnami.com/bitnami \
  --helm-chart nginx \
  --revision 11.0.0 \
  --values-literal-file values.yaml \
  --dest-namespace default \
  --dest-server https://kubernetes.default.svc
```

Once ArgoCD deploys the application or the Helm chart, the application is no longer managed by Helm. ArgoCD is responsible for monitoring and operating the application.\
Executing an `helm ls` command will not return the helm chart.
