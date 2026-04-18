---
title: 'HashiCorp Configuration Language Basics'
draft: false
weight: 4
series: ["Terraform"]
series_order: 4
---

The HCL file consists of Blocks and Arguments.\
A block is defined within curly braces, and it contains a set of arguments in key value pair format representing the configuration data.\
In its simplest form, a block in Terraform contains information about the infrastructure platform and a set of resources within that platform that we want to create.

Syntax:

```hcl
<block-name> "<provider>_<resource-type>" "<resource-name>" {
  <arguments>
}
```

Example:

```hcl
resource "local_file" "pet" {
  filename = "/root/pets.txt"
  content = "We love pets!"
}
```

inside the Resource block, we specify the file name to be created as well as its contents using the block arguments.

- **block-name:** The type of block specified above is called the Resource block, and this can be identified by the `resource` keyword in the beginning of the block.
- **resource type:** In the above example we have the resource type called `local_file`. A resource type provides two bits of information:
  - **provider:** Represented by the word before the underscore in the resource type. In the above example we are making use of the "local" provider.
  - **resource-type:** Represented by the word after the underscore in the resource type. It is "file" in the above example, represents the type of resource.
- **resource-name:** This is the logical name used to identify the resource, and it can be named anything. But the above example we have called it pet, as the file we are creating contains information about pets.
- **Arguments:** Within this block and inside the curly braces, we define the arguments for the resource which are written in key value pair format.\
These arguments are specific to the type of resource we are creating, which in the above example is the local file.\
The first argument is the filename. To this, we assign the absolute path to the file we want to create. In the above example, it is set to `/root/pets.txt`.\
The second argument is the content. to this, we assign content to the file by making use of the content argument.\
The words `filename` and `content` are specific to the `local_file` resource we want to create, and they cannot be changed. In other words, the resource type of `local_file` expects that we provide the argument of filename and content.

We now have a complete HCL configuration file that we can use to create a file by the name of "pets.txt".

A simple terraform workflow consists of four steps:

1. Write the configuration file.
1. Run the `terraform init` command.
    - This command will check the configuration file and initialize the working directory containing the `.tf` file.
    - One of the first things that this command does is understand that we are making use of the Local provider (in the above example) based on the resource type declared in the resource block. It will then download the plugin to be able to work on the resources declared in the `.tf` file.
1. Review the execution plan using the `terraform plan` command.
1. Apply the changes using the `terraform apply` command.
1. Optionally, we can use the `terraform show` to see the details of the resource that we just created.

Terraform supports over 100 providers, e.g. AWS, Azure, GCP, etc.\
We can look at the terraform documentation to see what resources we can create with what providers, and what arguments we need to pass, including which are mandatory and which are optional.
