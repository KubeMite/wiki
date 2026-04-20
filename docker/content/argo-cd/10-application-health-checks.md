---
title: 'Application Health Checks'
draft: false
weight: 10
series: ["Argo-CD"]
series_order: 10
---

ArgoCD continuously polls Git repositories for any new changes, and at the same time it will continuously check the status of Kubernetes resources.\
If ArgoCD has applied a deployment manifest it will monitor it. If it is unable to scale the deployment to the necessary number of replicas it will mark it as unhealthy.

## Health Check Types

There are various resource health checks that are included in ArgoCD:

- **Health status:** All resources are 100% healthy
- **Progressing:** Resource is unhealthy, but could still be healthy given time
- **Degraded:** Resource status indicates a failure or an inability to reach a healthy state in a timely manner
- **Missing:** - Resource is not present in the cluster
- **Suspended:** - Resource is suspended or paused, e.g. a paused Deployment
- **Unknown:** - Resource health assessment failed and actual health status is unknown

## Included Kubernetes Health Checks

There are integrated checks for specific Kubernetes resource types:

Service:

- Determine service type
- If service type is LoadBalancer, verifies that `status.loadBalancer.ingress` is not empty
- Verifies that hostname or IP has at least one value

Ingress

- Verifies that `status.loadBalancer.ingress` is not empty
- Verifies that hostname or IP has at least one value

PersistentVolumeClaim

- Verifies that `status.phase = Bound`

Deployments, ReplicaSet, StatefulSet, DaemonSet

- Verifies that the observed generation is equal to the desired generation
- Verifies that the updated replicas is equal to the desired replicas

## Custom Health Checks

If a health check is not available for the resource, a custom ArgoCD health check can be created.\
ArgoCD supports custom health checks written in Lua.\
Custom health checks are defined in the `argocd-cm` ConfigMap.

For example, for this config map:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-cm
data:
  MY-COLOR: blue
```

We can create a health check for a making sure that `MY-COLOR` is not blue:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  resource.customizations.health.ConfigMap: |
    hs = {}
    hs.status = "Healthy"
      if obj.data.MY-COLOR == "blue" then
        hs.status = "Degraded"
        hs.message = "Please set a color other than blue"
      end
    return hs
  timeout.reconciliation: 300s
```
