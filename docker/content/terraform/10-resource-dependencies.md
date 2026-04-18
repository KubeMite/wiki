---
title: 'Resource Dependencies'
draft: false
weight: 10
series: ["Terraform"]
series_order: 10
---

Terraform has multiple ways to map and define resource dependencies.

## Implicit Dependency

By linking resources using resource attributes, terraform knows which resources depend on which, and knows in which order to provision them. This is called an implicit dependency.

For the following resources:

```hcl
resource "local_file" "pet" {
  filename = var.filename
  content = "My favorite pet is ${random_pet.my-pet.id}"
}

resource "random_pet" "my-pet" {
  prefix = var.prefix
  separator = var.separator
  length = var.length
}
```

Terraform creates resources in the following order:

1. `random_pet` resource.
1. `local_file` resource.

When resources are deleted, they are deleted in reverse order:

1. `local_file` resource.
1. `random_pet` resource.

## Explicit Dependency

We don't have to use resource attributes in order to set provisioning order for resources.

We can use the `depends_on` argument to specify which resources need to be created before other resources can be created. This type of dependency is called an explicit dependency.\
Explicitly specifying a dependency is only necessary when a resource relies on some other resource indirectly, and it does not make use of a reference expression.

Syntax:

```hcl
<block-name> "<provider>_<resource-type>" "<resource-name>" {
  <arguments>
  depends_on = [
    <resource-type>.<resource-name>
  ]
}
```

Example:

```hcl
resource "local_file" "pet" {
  filename = var.filename
  content = "My favorite pet is Mr.Cat"
  depends_on = [
    random_pet.my-pet
  ]
}

resource "random_pet" "my-pet" {
  prefix = var.prefix
  separator = var.separator
  length = var.length
}
```
