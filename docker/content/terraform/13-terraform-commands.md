---
title: 'Terraform Commands'
draft: false
weight: 13
series: ["Terraform"]
series_order: 13
---

A collection of useful terraform commands

## `terraform validate`

Once we write a configuration file, we don't have to run `terraform plan` or `terraform apply` in order to check if the syntax is correct. We can use the `terraform validate` command.\
If everything is correct, we will see a successful validation message. Otherwise, the command will print the line in the file that is causing the error with hints to fix it.

## `terraform fmt`

This command scans the configuration files in the current working directory and formats the code into a canonical format.\
This is a useful command to improve the readability of terraform configuration files.
When we run the command, the files that changed in the configuration directory are displayed on the screen.

## `terraform show`

Print the current state of the infrastructure as seen by terraform.\
We can use the `-json` flag to print the output in a json format.

## `terraform providers`

Prints a list of all providers used in the configuration directory.\
We can append `mirror <path>` to the end of the command to copy provider plugins needed for the current configuration to `<path>`.

## `terraform output`

Prints all output variables in the configuration directory.\
We can also print the value of a specific variable by appending the variable name to the end of the command.

## `terraform refresh`

Syncs terraform state with the real-world infrastructure.\
Useful for when there were changes to resources outside of terraform control.\
The command is run automatically whenever we run `terraform plan` or `terraform apply`. This is done prior to terraform generating an execution plan. However, it can be bypassed by using the `-refresh=false` option with the commands `terraform plan` or `terraform apply`.

## `terraform graph`

Prints a visual representation of the dependencies of the terraform configuration or an execution plan.\
The output graph is in a format called DOT. In order to understand it, we will need a program such as [graphviz](https://graphviz.org/).
