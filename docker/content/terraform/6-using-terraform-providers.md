---
title: 'Using Terraform Providers'
draft: false
weight: 6
series: ["Terraform"]
series_order: 6
---

When we run `terraform init` within a directory containing the configuration files, Terraform downloads and installs plugins for the providers used within the configuration.\
These can be plugins for cloud providers such as AWS, GCP, Azure, or something as simple as the local provider that we used to create a local file type resource.

Terraform uses a plugin-based architecture to work with hundreds of such infrastructure platforms. Terraform providers are distributed by HashiCorp and are publicly available in the Terraform Registry at [https://registry.terraform.io](https://registry.terraform.io).

## Provider Types

There are three tiers of providers:

- **Official providers:** These providers are owned and maintained by HashiCorp, and include the major cloud providers such as AWS, GCP, and Azure.\
The local provider is also an official provider.
- **Partner providers:** These providers are owned and maintained by a third-party technology company that has gone through a partner provider process with HashiCorp.\
Some of the examples are the BIG-IP provider from F5 networks, Heroku, DigitalOcean, etc.
- **Community providers:** These providers are published and maintained by individual contributors of the HashiCorp community.

## Downloading and Installing Providers

A `terraform init` command, when run, shows the version of the plugin that has been installed. It is a safe command, and it can be run as many times as needed without impacting the actual infrastructure that is deployed

When running the `terraform init` command, the plugins are downloaded into a hidden directory called `.terraform/plugins` in the working directory containing the configuration files.

The plugin name (e.g. `hashicorp/local`) is also known as the source address. This is an identifier that is used by Terraform to locate and download the plugin from the registry.\
The first part of the name, which in this case is `hashicorp`, is the organizational namespace. This is followed by the type, which is the name of the provider such as local.\

The plugin name can also optionally have a hostname in front. The hostname is the name of the registry where the plugin is located.\
If omitted, it defaults to `registry.terraform.io`, which is HashiCorp's public registry. Given the fact that the local provider is stored in the public Terraform Registry within the HashiCorp namespace, the source address for it can be represented as `registry.terraform.io/hashicorp/local`, or simply by `hashicorp/local` by omitting the hostname.

## Provider Versions

By default, Terraform installs the latest version of the provider. Provider plugins, especially the official ones, are constantly updated with newer versions. This is done to bring in new functionality or to add in bug fixes, and these can introduce breaking changes to our code.\
We can lock down our configuration files to make use of a specific provider version as well.

## Multiple Providers

Terraform supports the use of multiple providers within the same configuration. In the following file we use both the `local` provider as well as the `random` provider:

```hcl
resource "local_file" "pet" {
  filename = "/root/pets.txt"
  content = "We love pets!"
}

resource "random_pet" "my-pet" {
  prefix = "Mrs"
  separator = "."
  length = "1"
}
```
