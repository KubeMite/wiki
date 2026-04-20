---
title: 'Installation Options'
draft: false
weight: 7
series: ["Argo-CD"]
series_order: 7
---

ArgoCD has two types of installations

## Core

- Installs minimal non-HA version of each components and excludes the API server and user interface
- Best suited for users who use the ArgoCD alone and do not require multi-tenancy
- Simpler to set up and has fewer components

## Multi-Tenant

- Utilized by organizations with various application developer teams and is kept up to date by separate platform teams
- In this method there are two different installation option: Non high Availability & High availability
- Each of the installation options provides an install.yaml and a namespace-install.yaml manifests

### Non high Availability

- Not suggested for production use
- Mostly used for evaluation for testing and proof of concepts
- Doesn't configure multiple replicas for supported components

### High Availability

- Suggested for production use
- Configures multiple replicas for supported components

### install.yaml

- Provides a standard installation with cluster admin access to ArgoCD
- Use this if you intend to deploy applications in the same cluster where ArgoCD is running (can still deploy application to remote clusters as well)

### namespace-install.yaml

- Provides an installation which only requires namespace level access
- Use this manifest if you want ArgoCD to rely on provided credentials to deploy applications to remote clusters, and don't need ArgoCD to deploy applications in the same cluster that it is running in
- With the correct credentials can still deploy applications to the local cluster as well
