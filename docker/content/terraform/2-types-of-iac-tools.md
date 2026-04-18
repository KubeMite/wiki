---
title: 'Types of IAC Tools'
draft: false
weight: 2
series: ["Terraform"]
series_order: 2
---

## What is Infrastructure as Code?

The most effective way to provision cloud infrastructure is to codify the entire process. Infrastructure as Code (IaC) allows us to write and execute code to define, provision, configure, update, and destroy resources such as databases, networks, storage, and application configurations.

**Why not just use shell scripts?** Shell scripts require advanced programming skills to build, are difficult to manage, house complex logic, and are rarely reusable. IaC tools use simple, human-readable high-level languages that make massive deployments manageable and maintainable.

## Categories of IaC Tools

The IaC family contains many tools (e.g., Ansible, Terraform, Puppet, CloudFormation, Packer, SaltStack, Vagrant, Docker), each designed to solve specific problems.\
They can be broadly classified into three categories:

| Category | Primary Purpose | Common Tools |
| --- | --- | --- |
| **Configuration Management** | Installing and managing software on existing infrastructure. | Ansible, Puppet, Chef, SaltStack |
| **Server Templating** | Creating custom, immutable images of VMs or containers. | Docker, Packer, Vagrant |
| **Infrastructure Provisioning** | Provisioning raw infrastructure components using declarative code. | Terraform, CloudFormation |

### Configuration Management Tools

These tools manage the software installed on existing servers, databases, and networking devices. They maintain a consistent code structure that can be checked into version control, reused, and run on multiple remote resources simultaneously.\
Their most powerful feature is **idempotency**: we can run the code multiple times, and it will only make the specific changes necessary to bring the system to the defined state, leaving already-correct configurations alone.

### Server Templating Tools

Templating tools create custom images containing all necessary software and dependencies, eliminating the need to install software *after* deployment. Examples include VM images on OSBoxes, custom AWS AMIs, and Docker images.\
These tools promote **immutable infrastructure**; if a change is required, we do not update the running instance (as we would with Ansible). Instead, we update the template image and deploy a brand-new instance.

### Infrastructure Provisioning Tools

These tools deploy the foundational infrastructure components (such as virtual machines, VPCs, subnets, security groups, and storage) using declarative code.\
While tools like CloudFormation are strictly tied to AWS, Terraform is vendor-agnostic and uses provider plugins to support almost all major cloud environments.
