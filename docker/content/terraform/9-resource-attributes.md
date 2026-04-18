---
title: 'Resource Attributes'
draft: false
weight: 9
series: ["Terraform"]
series_order: 9
---

We can link resources together using resource attributes.

We can use resource attributes to use the output of one resource as the input of another.\
Many resources have attributes, which we can access from other resources.\
We can see which attributes a resource has in its documentation.

Let's take for example the following resources:

```hcl
resource "local_file" "pet" {
  filename = var.filename
  content = var.content
}

resource "random_pet" "my-pet" {
  prefix = var.prefix
  separator = var.separator
  length = var.length
}
```

We can reference the id of the `random_pet` resource by using the syntax `${<resource-type>.<resource-name>.<attribute>}`.

For example:

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
