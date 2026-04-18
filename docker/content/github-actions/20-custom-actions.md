---
title: 'Custom Actions'
draft: false
weight: 21
series: ["Github Actions"]
series_order: 21
---

There are several reasons why we might need to use custom actions instead of using actions from the marketplace:

- **Tailored automation:** Our project might have a specific requirement that is not fully met by existing community actions. Custom actions allow us to tailor automation to our project's needs.
- **Integrates proprietary or legacy systems:** If our project relies on proprietary or legacy systems that are not supported by community actions, creating custom actions becomes necessary to integrate the systems into our workflow.
- **Flexibility and control:** For complex workflows that involve multiple steps, conditional logic, or complicated dependencies, custom actions offer great flexibility and control.
- **In-house solutions:** Some organizations might have strict security compliance requirements and prefer to have in-house development for critical parts of the CI/CD pipelines to have full control and avoid external dependencies.

Custom GitHub actions provide the flexibility, control, and adaptability required to address specific and unique needs that may arise in our project. They complement community actions by allowing us to extend and customize our automation workflows as necessary.

## Creating Custom Actions

We can create custom actions by writing custom code that can interact with publicly available third party APIs and services.\
While custom actions can be created anywhere in a repository, it is recommended to create each custom action in the `.github/custom-actions/<action-name>` directory of a repository for organizational reasons. All files relating to a specific action should be in the specified directory.\
All custom actions require a metadata file that uses a YAML syntax. The file must be named `action.yml` or `action.yaml`. The metadata file will contain info about the custom actions, such as name, author, description, inputs, outputs, etc.\
Each metadata file may look different, depending on the type of custom action we choose to create.

## Types of Custom Actions

There are three types of GitHub custom actions.

### Composite

Allow us to combine multiple workflow steps within one action.

This action can be executed on any Linux, MacOS and Windows runners.

The benefit of composite actions is it can be used to simplify our workflows and make them more reusable.\
It can be more complex to create and maintain than other types of actions, because we need to think about how the different steps in the composite action will interact with each other.

#### Creating a Composite Action

General template for the metadata file (`action.yml`) for a composite action:

```yaml
name: '<custom-composite-action-name>'
description: '<custom-composite-action-description>'
inputs:
  <input-id>:
    description: <description-of-input>
    required: <true|false>
runs:
  using: "composite"
  steps:
    <steps as defined in a normal workflow file>
```

- We can access input values by using `${{ inputs.<input-id> }}`.

We must specify a shell for the commands to run in as seen in the example below:

```yaml
name: 'NPM Custom Action'
description: 'Installing and caching NPM packages'
inputs:
  path-of-folder:
    description: 'The path to cache'
    required: true
runs:
  using: "composite"
  steps:
    - name: Cache NPM dependencies
      uses: actions/cache@v3
      with:
        path: ${{ inputs.path-of-folder }}
        key: ${{ runner.os }}-node-modules-${{ hashFiles('package-lock.json') }}

    - name: Install Dependencies
      run: npm install
      shell: bash
```

#### Using a Composite Action in a Workflow

We can use a composite action in a workflow by specifying the relative path to it in a step.

Assuming that the composite action is in the same repository as the workflow:

```yaml
jobs:
  <job_name>:
    steps:
      - name: Using Composite Action
        uses: ./.github/<path-to-custom-action-dir>
        with:
          <input-id>: <input-value>
```

Or if the composite action is in a different repository from the workflow:

```yaml
jobs:
  <job_name>:
    steps:
      - name: Using composite Action
        uses: <org-name>/<repo-name>@<ref>
        with:
          <input-id>: <input-value>
```

- `<ref>` ref can be a branch name, a tag or a commit sha.

### Docker Container

Runs in a Docker container, which provide a clean and isolated environment for running our code.\
Docker actions are a good choice for tasks that require a specific environment.

Docker actions can only be executed on runners with a Linux operating system.

Docker is the ideal option because we can customize the operating system and the tools, but we need to have Docker expertise to build and maintain this action.\
This action type uses a DockerFile to build and run the containers. Because of the latency of pulling the Docker image, docker container actions are slower than other custom actions.

#### Creating a Docker Container Action

To create a docker container action, we first must create a new directory for it. We then place a Dockerfile in the directory and any additional scripts that the Dockerfile will use. We also place the following `action.yml` file in the directory:

```yaml
name: <docker-container-action-name>
description: <docker-container-action-description>
inputs:
  <input-id>:
    description: <description-of-input>
    required: <true|false>
runs:
  using: 'docker'
  image: <path-to-dockerfile>
  args:
    - <argument-1-for-dockerfile>
    - <argument-2-for-dockerfile>
```

- We can access an input value by using `${{ inputs.<input-id> }}`.

#### Using a Docker Container Action

We can use a docker container action in a workflow by specifying the relative path to it in a step. Assuming that the docker container action is in the same repository as the workflow:

```yaml
jobs:
  <job_name>:
    steps:
      - name: Using Docker Container Action
        uses: ./.github/<path-to-custom-action-dir>
        with:
          <input-id>: <input-value>
```

Or if the docker container action is in a different repository from the workflow:

```yaml
jobs:
  <job_name>:
    steps:
      - name: Using Docker Container Action
        uses: <org-name>/<repo-name>@<ref>
        with:
          <input-id>: <input-value>
```

- `<ref>` ref can be a branch name, a tag or a commit sha.

### JavaScript

Written using JavaScript, can use NodeJS and all of its dependencies.

This action type can execute on any Linux, MacOS and Windows runners.

JavaScript actions can run directly on a runner machine and executes faster than a Docker container action.\
JavaScript actions are lightweight and do not require a lot of resources to run. This makes them ideal for tasks that are quick and simple.

JavaScript actions are not as isolated as docker container actions, as they run directly on the runner machine, so there could be potential interference with other actions using the same runner.

#### Create and Use a JavaScript action

Please refer to the [official documentation](https://docs.github.com/en/actions/creating-actions/creating-a-javascript-action).
