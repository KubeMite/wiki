---
title: 'Input Variables'
draft: false
weight: 8
series: ["Terraform"]
series_order: 8
---

Input variables are used to provide a set of variables the configuration code can use to deploy infrastructure.\
They allow the end user to simply pass variables to the configuration code, and to ensure that the configuration code doesn't use hardcoded values.\
Input variables should be defined in a file called `variables.tf`

## Setting Input Variables

Syntax:

```hcl
variable "<variable-name>" {
  default = "<default-value>"
  type = <variable-type>
  description = "<variable-description>"
}
```

- **default:** Default variable value. If no input value is specified, this value will be used.
- **type:** Enforces the type of variable being used. If unset will be set to any.\
Can be one of the following:
  - **string:** An alphanumeric value consisting of variables and numbers.
  - **number:** A single value of a positive or negative number.
  - **bool:** `true` or `false`.
  - **any:** Accepts any value.
  - **list (or tuple):** A numbered collection of values, e.g. `["us-west-1a", "us-west-1c"]`.\
  Can be accessed by `<var-name>[<index>]`, index starts at 0.\
  List must contain only the same element type, while tuple can contain elements of different types.
  - **set:** A collection of unique values. Like list, but cannot have duplicate values.
  - **map (or object):** A group of values where each is identified by named labels, like `{name = "Mabel", age = 52}`.\
  Can be accessed by `<var-name>["<key>"]`.
  - Values can be combined, e.g. a map containing a list. in that case, we will specify in the type variable `map(list)`.
- **description:** Describes what the variable is used for.

Example:

```hcl
variable "filename" {
  default = "/root/pets.txt"
  type = string
}

variable "content" {
  default = "We love pets!"
}

variable "prefix" {
  default = "Mrs"
}

variable "separator" {
  default = "."
}

variable "length" {
  default = "1"
}
```

## Using Input Variables

We can use variables like so:

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

- When using variables, we don't need to use double quotes (`"`), since they are used in the variable definition.
- When we use variables without a set value and then run terraform apply, we will be prompted to enter values for the variables.

## Manual Value Input

We can specify the value of input variables in a variety of ways:

### Command-Line Flags

We can set the value of input variables by passing the value using command line arguments:

```sh
terraform apply -var "<var-name-1>=<var-value-1>" -var "<var-name-2>=<var-value-2>"
```

### Environment Variables

We can set the value of input variables to the value of environment variables by prefixing the environment variable with `TF_VAR_`:

```sh
export TF_VAR_<var-name-1>=<var-value-1>
export TF_VAR_<var-name-2>=<var-value-2>
terraform apply
```

### Variable Definition File

We can set the value of input variables by passing the value in a variable definition file.

Any file in the configuration directory called `terraform.tfvars` (parsed as HCL) or `terraform.tfvars.json` (parsed as JSON) or end with `.auto.tfvars` (which will be parsed as HCL) or `.auto.tfvars.json` (which will be parsed as JSON) will be automatically loaded when running `terraform apply`.

The variable definition file should be structured like so:

```hcl
<var-name-1> = <var-value-1>
<var-name-2> = <var-value-2>
```

We can also use a variable definition file that doesn't match any of the above names or extensions.\
The file won't be loaded automatically, so we will need to specify it manually:

```sh
terraform apply -var-file <variable-file>
```

### Multiple Options

We can use multiple options together to assign value to input variables, e.g. environment variables and variable definition file.

If we assign a value to a variable in multiple places, terraform will follow the variable definition precedence to understand which value to accept.\
Terraform loads the following sources in the following order:

1. Environment variable.
2. `terraform.tfvars` file or `terraform.tfvars.json`.
3. Any file ending in `.auto.tfvars` or `.auto.tfvars.json` in alphabetical order.
4. `-var` or `-var-file` (command-line flags).

If a variable is assigned a value in multiple sources, the later source will override the earlier source.
