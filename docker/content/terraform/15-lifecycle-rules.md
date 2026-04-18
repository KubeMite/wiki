---
title: 'LifeCycle Rules'
draft: false
weight: 15
series: ["Terraform"]
series_order: 15
---

When terraform updates a resource, it first deletes it and then re-creates it with the updated configuration.\
We can avoid that by using lifecycle rules.

Syntax:

```hcl
resource "local_file" "pet" {
  filename = "/root/pets.txt"
  content = "We love pets!"
  file_permission = "0700"

  lifecycle {
    <rule> = <value>
  }
}
```

- `<rule>:` The rule we want to enable or disable for the resource block, or any values we want to pass to the rule.

There are several rules we can use to control the lifecycle of a resource.

## `create_before_destroy`

Ensures that when a change in the configuration forces the resource to be re-created, a new resource is created first before deleting the old one.\
It is important to be cautious when using this rule, since if we can cause a state where the resource is being destroyed instead of re-created.

For example, if we use the `create_before_destroy` rule for a local file with the same path, terraform will attempt to create it but it can't since the file already exists, then delete it.\
We expected the resource to still exist at the end of the `terraform apply`, but it was destroyed.

## `prevent_destroy`

Terraform will reject any changes that will result in the resource getting destroyed and will display an error message.\
Useful for databases provisioned using terraform.

The resource can still be destroyed using the `terraform destroy` command.

## `ignore_changes`

Prevents a resource from being updated based on a list of attributes that we define within the lifecycle block.

For example, for the following resource block:

```hcl
resource "aws_instance" "webserver" {
  ami = "ami-Gab43b6zaf89gt249"
  instance_type = "t2.micro"
  tags = {
    Name = "my-webserver"
  }
}
```

If we change the tag in the webserver itself and not in the resource definition that terraform uses, on the next `terraform apply` terraform will attempt to re-create the webserver with the tag that is specified in the configuration file.\
If we don't want that to happen, we can using the `ignore_changes` rule to ensure that terraform ignores the change between the real-world tag and the tag specified in the configuration file:

```hcl
resource "aws_instance" "webserver" {
  ami = "ami-Gab43b6zaf89gt249"
  instance_type = "t2.micro"
  tags = {
    Name = "ProjectA-webserver"
  }
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
```

In `ignore_changes`, we can specify any attributes we want terraform to ignore.\
We can also specify the `all` keyword, which will make terraform completely ignore any changes that occurred to the resource.
