---
title: 'ArgoCD Overview: Features and Concepts'
draft: false
weight: 6
series: ["Argo-CD"]
series_order: 6
---

Argo CD is a declarative, GitOps continuous delivery tool specifically designed for Kubernetes resources defined within a Git repository. It continuously monitors running applications, comparing their live state against the desired state defined in Git. When deviations occur, Argo CD reports them and provides visualizations, empowering developers to manually or automatically synchronize the live state with the desired state.

## Why Use ArgoCD?

- **GitOps Adoption:** It extends the inherent benefits of declarative specifications and Git-based configuration management.
- **Continuous Operations:** It serves as the vital first step toward achieving continuous operations through monitoring, analytics, and automated remediation.
- **Enterprise Readiness:** It is highly enterprise-friendly, supporting multi-cluster deployments alongside auditability, compliance, security, Role-Based Access Control (RBAC), and Single Sign-On (SSO).

## How Does it Work?

ArgoCD adheres strictly to the GitOps pattern, relying on Git repositories as the absolute source of truth for both the desired state of applications and the target deployment environments. It automates the synchronization of this desired state with specified target environments.

ArgoCD natively supports several configuration management tools, including:

- [Kustomize](https://kustomize.io/) applications
- [Helm](https://helm.sh/) charts
- [Ksonnet](https://github.com/ksonnet/ksonnet) applications
- [Jsonnet](https://jsonnet.org/) files
- Plain YAML/JSON manifests

## Core Concepts & Terminology

To utilize ArgoCD effectively, teams should be familiar with foundational concepts like Git, Docker, Kubernetes, CI/CD, and general GitOps principles. Within ArgoCD itself, specific terminology is used:

- **Application:** A distinct group of resources defined by a manifest.
- **Application Source Type:** The specific templating tool used to build the application (e.g., Helm, Kustomize, Ksonnet).
- **Project:** A logical grouping of applications. This is highly useful for managing multi-tenant environments where ArgoCD is shared by multiple teams.
- **Target State:** The desired state of an application, strictly represented by the files committed in the Git repository.
- **Live State:** The actual running state of the application in the cluster (e.g., the existing Pods, ConfigMaps, and Secrets currently deployed).
- **Sync Status:** A metric indicating whether the live state matches the target state (i.e., is the cluster identical to Git?).
- **Sync:** The mechanical process of transitioning an application to its desired state by applying the necessary changes to the Kubernetes cluster.
- **Sync Operation Status:** A simple indicator of whether a recent sync attempt succeeded or failed.
- **Refresh:** The action of comparing the latest code in Git with the live state to determine what is different.
- **Health:** An analysis of the application's functionality. It answers: Is the app running correctly and capable of serving requests?

## Key Features

ArgoCD provides a robust set of features out-of-the-box:

- Automated deployment of applications across multiple target clusters.
- Detailed audit trails for application events and API calls.
- Extensive SSO integration supporting OIDC, OAuth2, LDAP, SAML 2.0, GitHub, GitLab, Microsoft, and LinkedIn.
- Webhook integrations for GitHub, BitBucket, and GitLab.
- The ability to rollback or "roll-anywhere" to any application configuration ever committed to the Git repository.
- A comprehensive Web UI providing a real-time view of application activity.
- Automated detection and visualization of configuration drift.
- Out-of-the-box Prometheus metrics for deep observability.
- Multi-tool support for templating engines (Kustomize, Helm, Ksonnet, Jsonnet, plain-YAML).
- Complex rollout support (like blue/green and canary upgrades) via PreSync, Sync, and PostSync lifecycle hooks.
- Secure multi-tenancy enforced by strict RBAC authorization policies.
- A dedicated CLI and access tokens to facilitate CI integration and external automation.
- Built-in health status analysis of all managed application resources.
- The flexibility to choose between automated continuous syncing or manual syncing of applications to their desired state.
