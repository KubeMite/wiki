---
title: 'Bash'
draft: false
series: ["Laptop Setup"]
---

This guide details how I configured my laptop in order to work with [Bash](https://www.gnu.org/software/bash/)

In order to create Bash scripts in VSCode it is recommended to use the following extension which provides recommendations, syntax highlighting, and info-on-hover:

- [bash-ide-vscode](https://marketplace.visualstudio.com/items?itemName=mads-hartmann.bash-ide-vscode)

The extension requires the following packages to be installed:

```sh
brew install shellcheck shfmt
```

And Bash should be updated to the latest version (the default bash shipped with MacOS is 3.2 which is outdated)

```sh
brew install bash
```

Then add Homebrew bin folder to path for new bash binary to be used when calling the bash command by adding the following lines to your ~/.zshrc:

```sh
## Add Homebrew bin folder to path
export PATH="/opt/homebrew/bin:$PATH"
```
