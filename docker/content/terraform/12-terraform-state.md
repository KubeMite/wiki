---
title: 'Terraform State'
draft: false
weight: 12
series: ["Terraform"]
series_order: 12
---

When we first run `terraform plan` or `terraform apply`, terraform will try to refresh the state in-memory prior to the plan.\
Since this is our first run there will be no state saved, and terraform will understand that there are currently no resources provisioned.\
For every resources created, terraform assigns a unique ID.

For every subsequent run of `terraform plan` or `terraform apply`, terraform will refresh the in-memory state, which will have the resources created and their IDs.

## Where is the State Saved?

Terraform creates or alters a file called `terraform.tfstate` when we run `terraform plan` or `terraform apply`. This file exists in the same directory as the rest of the terraform files, and it is called the terraform state file.\
The state file is a json data structure that maps the real-world infrastructure resources to the resource definition in the configuration files.\
Terraform alters the value in the state file to reflect the real world value of resources.\
This mapping allows terraform to create execution plans when a drift is identified between the resource configuration files and the state.\

## Benefits of State

Besides mapping between resources and the configuration in the real world, the state file also tracks metadata details such as resource dependencies.\
For example, If we were to create 3 resources, and then delete 2 of them and run `terraform apply` for only the last resource, terraform will compare the resource in the terraform file with the terraform state and know to delete the 2 resources, since they don't appear in the terraform file but they do in the state.

The state file also improves performance. It is used as a cache for the state of the resources.\
Instead of having to fetch the resource status for every provider over possibly thousands of resources for every `terraform plan` or `terraform apply` command, we can simply look at the state file and see the state of all of the resources.

However, we can append the `--refresh=false` flag for every terraform command that uses state in order to force terraform to fetch the state from the providers, even if the state file exists.

The State file is also important for collaboration as a team.\
The latest version of a state file should be shared between all members of a team in a remote state store (AWS S3, HashiCorp Consul, Terraform Cloud, etc.).

## Terraform State Considerations

There are a few considerations to keep in mind when working with the terraform state:

- State is a non optional feature and the state file contains sensitive information, including ssh key-pairs, IP addresses, passwords, etc.\
For that reason, it is considered best practice to store the configurations files in a distributed version control system, but not to store the state file is such a system but in a remote backend system such as S3, terraform cloud, etc.\
We should never manually change the state file, but instead rely on `terraform state` commands.
- Every user in a team should ensure nobody else runs terraform commands that may alter the state file at the same time, since failure to do so can result in unexpected behavior due to the state file being edited by multiple processes at the same time.
