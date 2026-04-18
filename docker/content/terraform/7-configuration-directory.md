---
title: 'Configuration Directory'
draft: false
weight: 7
series: ["Terraform"]
series_order: 7
---

Example configuration directory file structure:

```text
.
├── main.tf
├── provider.tf
├── outputs.tf
├── variables.tf
└── modules/
```

- **main.tf:** The primary entry point where most resources are declared.
- **provider.tf:** Specifies required providers and their versions.
- **outputs.tf:** Defines output values to be returned after an apply.
- **variables.tf:** Defines input variables for the configuration.
- **modules:** A subdirectory for nested modules used by the root configuration.
