---
title: 'Why Terraform'
draft: false
weight: 3
series: ["Terraform"]
series_order: 3
---

Terraform is a free, open-source enterprise-grade provisioning tool developed by HashiCorp. It installs as a single binary, allowing teams to build, manage, and destroy infrastructure in minutes across multiple platforms. From on-premise vSphere clusters to public clouds like AWS, GCP, and Azure.

Terraform achieves this extensive compatibility through **Providers**. Providers allow Terraform to interact with third-party platform APIs. Beyond standard cloud computing, providers enable Terraform to manage network infrastructure (Cloudflare, Palo Alto), monitoring tools (DataDog, Grafana), databases (MongoDB, PostgreSQL), and version control systems (GitHub, GitLab).

## HashiCorp Configuration Language (HCL)

Terraform uses HCL, a simple, declarative language used to define infrastructure resources within `.tf` configuration files.

Because the language is declarative, you define the *desired state* of your infrastructure, and Terraform figures out how to achieve it. The code can be easily maintained in version control and shared across teams.

```hcl
resource "aws_instance" "webserver" {
  ami           = "ami-Gab43b6zaf89gt249"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "finance" {
  bucket = "finance-24392857"
  tags = {
    Description = "Finance and Payroll"
  }
}

resource "aws_iam_user" "admin_user" {
  name = "lucy"
  tags = {
    Description = "Team Leader"
  }
}
```

## The Terraform Workflow

Terraform calculates the delta between the real-world infrastructure and your configuration files, executing operations in three distinct phases:

1. **Init:** Initializes the project and identifies/downloads the providers required for the target environment.
1. **Plan:** Drafts an execution plan detailing exactly what will be added, changed, or destroyed to reach the target state.
1. **Apply:** Executes the necessary API calls to the target environment to bring the infrastructure into the desired state.

If an environment drifts from its desired state, running terraform apply again will automatically fix the missing or altered components.

## State and Lifecycle Management

Every object Terraform manages is called a resource (e.g., a compute instance or a database). Terraform manages the entire lifecycle of these resources from provisioning to decommissioning.

It does this by recording a "blueprint" called the **State**, which tracks the infrastructure exactly as it exists in the real world. Furthermore, Terraform can use data sources to read attributes of existing external infrastructure, or import manually created resources to bring them under Terraform's automated management.

For larger teams, Terraform Cloud and Enterprise offer centralized UIs, improved security, and seamless collaboration features.
