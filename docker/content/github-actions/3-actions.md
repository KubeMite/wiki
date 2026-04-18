---
title: 'Actions'
draft: false
weight: 3
series: ["Github Actions"]
series_order: 3
---

Actions within Github workflows are prebuilt, reusable automation components designed for a specific task. These actions can be created by you, or by the members of the community, making it easy to share and reuse automation logic.

Actions can be located within the [Github Marketplace](https://github.com/marketplace).

Actions bearing the tick badge indicate that Github has verified the creator of the action as a partner, while Actions without tick badges are created by members of the community. They can be utilized, but it is advised to read the source code beforehand.

## Adding an Action to a Workflow

We can specify an action by using it as a step in a workflow:

```yaml
- name: <step-name>
  uses: <action-organization>/<action-repo>@<action-version>
```

To pass inputs into the action step, use the `with` keyword:

```yaml
- name: <step-name>
  uses: <action-organization>/<action-repo>@<action-version>
  with:
    <input-key>: <input-value>
```

For example, the following workflow uses the checkout action and the setup-node action.\
The setup-node action receives as an input the node version to set up.

```yaml
name: My Awesome App
on: push
jobs:
  unit-testing:
    name: Unit Testing
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Install NodeJS
        uses: actions/setup-node@v3
        with:
          node-version: 20
      - name: Install Dependencies
        run: npm install
      - name: Run Unit Tests
        run: npm test
```

## Setting Action Version

We can specify the action version in three ways:

- **Tags:** append `@<tag_name>` to the end of the action.
- **Branch:** append `@<branch_name>` to the end of the action. This will take the latest commit of the branch. This is not recommended since new commits may contain breaking changes.
- **Sha:** Append `@<sha>` to the end of the action. This will specify the commit we want to use.
  - This is the recommended way to specify the version of an action (taking the commit sha of a specific tag) since the commit sha will not change without our knowledge
