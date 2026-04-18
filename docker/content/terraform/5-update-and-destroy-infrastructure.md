---
title: 'Update and Destroy Infrastructure'
draft: false
weight: 5
series: ["Terraform"]
series_order: 5
---

We can update resources by changing their value in the `.tf` file, and then running the following command:

```sh
terraform apply
```

Terraform will try to alter the resource state, but if the remote API doesn't allow that, it will destroy and re-create the resource.

We can destroy resources by running the  command command:

```sh
terraform destroy
```
