---
title: 'User Management & RBAC'
draft: false
weight: 16
series: ["Argo-CD"]
series_order: 16
---

## User management

By default ArgoCD has one built-in user, the admin user. It has full access to every resource in the system. It is recommended to use the admin user only for the initial setup and then disable it after adding all required users.

ArgoCD supports two types of users: local users and SSO users (through integrating ArgoCD with Okta or similar SSO products).

New users can be defined using the ArgoCD config map:

```sh
kubectl -n argocd patch configmap argocd-cm --patch='{"data":{"accounts.<username>": "apiKey,login"}}'
```

- apiKey - allows generating JWT for API access
- login - allows logging in using the Web UI

We can update user password using:

```sh
argocd account update-password --account my-account
```

or

```sh
argocd account update-password \
  --account my-account \
  --new-password my-new-password \
  --current-password my-current-password
```

By default new users have no access.

ArgoCD has 2 predefined default roles:

- role:readonly - provides read only access to all of the resources
- role:admin - provides full access to all of the resources

Example of assigning the readonly role to any user without a role:

```sh
kubectl -n argocd patch configmap argocd-cm --patch='{"data":{"policy.default": "role:readonly"}}'
```

## RBAC

RBAC control in ArgoCD is done using policies. Policies are defined in CSV notation and are applied to either a user or an SSO group.

RBAC permission definitions differ between applications and other resource types in ArgoCD.\
For resources that belong to a project (applications, logs and exec) the policy CSV is of the form `p, <role/user/group>, <resource>, <action>, <project>/<object>`.\
For resources that don't belong to a project (all other resources) the policy is of the form `p, <role/user/group>, <resource>, <action>, <object>`.

To create a policy we need to edit the `policy.csv` field under the `data` field in the `argocd-rbac-cm` config map in the **argocd** namespace:

```sh
kubectl -n argocd patch configmap argocd-rbac-cm \
  --patch='{"data":{"policy.csv":"p, role:create-cluster, clusters, create, *, allow\ng, my-account, role:create-cluster"}}'
```

The above command creates a role name `create-cluster` which can create clusters, then assigns it to the user `my-account`.\
Now when `my-account` runs the command `argocd account can-i create clusters '*'` the response will be `yes`, but when my-account runs the command `argocd account can-i delete clusters '*'` the response will be `no`.
