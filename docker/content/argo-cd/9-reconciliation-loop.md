---
title: 'Reconciliation Loop'
draft: false
weight: 9
series: ["Argo-CD"]
series_order: 9
---

The reconciliation function tries to match the actual state of the Kubernetes cluster to the desired state defined in Git.\
ArgoCD uses a reconciliation loop to synchronize from the Git repository.

In the Devops world multiple teams commit changes multiple times per day, possibly very closely to one another, and we don't necessarily want to synchronize for each one. For this reason, ArgoCD synchronizes to the cluster every 3 minutes by default.\
This is set in the ArgoCD repo server under the option application reconciliation timeout in the **argocd-cm** ConfigMap.

Instead of the ArgoCD repo server polling the Git repository every 3 minutes, we can set the ArgoCD API server to receive webhook events from the Git repository provider.\
Within our Git provider we can create the webhook by defining the ArgoCD server instance endpoint appended with `/api/webhook`.
