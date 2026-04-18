---
title: 'Mutable vs Immutable Infrastructure'
draft: false
weight: 14
series: ["Terraform"]
series_order: 14
---

## Mutable vs Immutable Infrastructure

When terraform updates a resource, such as changing the permissions of a file, it destroys it and then re-creates it.\
It does that because terraform as an infrastructure provisioning tool uses an immutable approach.

Mutable infrastructure means that we can update an existing resource. Immutable infrastructure means that we cannot update an existing resource, we must delete it and re-create it with the update.

Terraform uses an immutable approach because it prevents configuration drift and complexity. This avoid the problem that can happen with mutable infrastructure of gradually changing dependencies on different resources (that can, for example, block an upgrade) of some of the resources due to different configurations on each resource.\
For this reason, terraform uses immutable infrastructure.

Terraform first deletes the resource, then re-creates it with the updated configuration. We can make terraform change this behavior by using lifecycle rules within our resource blocks.
