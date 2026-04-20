---
title: 'Multi-Cluster Application Deployment'
draft: false
weight: 15
series: ["Argo-CD"]
series_order: 15
---

ArgoCD can deploy applications both in the same cluster it is running as well as to a different cluster based on provided credentials.

To make ArgoCD deploy to external clusters, we need to use the following steps:

1. Create an external cluster
1. On the cluster where ArgoCD is deployed, add the credentials of the external cluster to the kubeconfig file:

   ```sh
   kubectl config set-cluster prod --serverhttps://1.2.3.4 --certificate-authority=prod.crt
   kubectl config set-credentials admin --client-certificate=admin.crt --client-key=admin.key
   kubectl config set-context admin-prod --cluster=prod --user=admin --namespace=prod-app
   ```

1. On the cluster where ArgoCD is deployed, add the external cluster to ArgoCD using the CLI tool:

   ```sh
   argocd cluster add admin-prod
   ```

   The credentials to the external cluster will be stored as secrets within the ArgoCD namespace

1. Now we can select the external cluster as a target or destination for ArgoCD applications
1. We can check the list of external clusters ArgoCD can deploy to with the following command:

    ```sh
    argocd cluster list
    ```
