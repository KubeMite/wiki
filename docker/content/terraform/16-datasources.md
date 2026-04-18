---
title: 'Datasources'
draft: false
weight: 16
series: ["Terraform"]
series_order: 16
---

Datasources allow terraform to read attributes from resources which are provisioned outside its control.

## Syntax

To read attributes from resources not provisioned by terraform, we use the data block:

```hcl
data "<provider>_<resource-type>" "<resource-name>" {
  <arguments>
}
```

- **arguments** - must supply enough arguments to identify the resource

## Example

An example where we read the data of a resource provisioned outside of terraform:

```hcl
data "local_file" "pet" {
  filename = "/root/pets.txt"
  content = data.local_file.dog.content
}

data "local_file" "dog" {
  filename = "/root/pets.txt"
}
```

Even though we didn't specify the `content` argument in the data block, we can still access it since it is of a `local_file` type.\
The arguments in the `data` block are only used for identifying the resource.
