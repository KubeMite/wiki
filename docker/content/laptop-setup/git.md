---
title: 'Git'
draft: false
series: ["Laptop Setup"]
---

I prefer using the official Git version rather than the Apple one:

```sh
brew install git
```

Make sure to restart the terminal after install for the new git version to take effect.

## Using VSCode for Interactive Rebases

When changing old commit messages, commit order, or sqashing commits, the best way is to use `git rebase`. But using `git rebase` in the terminal is inconvenient at best, so it is better to use a GUI via VSCode:

1. Install the [gitlens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) extension for VSCode.
1. Configure git to use VSCode for its interactive rebase:

    ```sh
    git config --global core.editor "code --wait"
    git config --global sequence.editor "code --wait --reuse-window"
    ```

1. Ensure that in GitLens settings the Interactive Rebase Editor is enabled.
    Cmd + Shift + P -> `gitlens: Open Settings` -> Make sure that `Interactive Rebase Editor` is enabled.
