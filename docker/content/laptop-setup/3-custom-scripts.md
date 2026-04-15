---
title: 'Custom Scripts'
draft: false
weight: 3
series: ["Laptop Setup"]
series_order: 3
---

I created some custom scripts in order to make maintaining my machine easier

The scripts live in this folder: `~/scripts`

Add the scripts folder to the PATH by adding this to `~/.zshrc`:

```sh
# Custom scripts directory
export PATH="$HOME/scripts:$PATH"
```

## Upgrade

This script upgrades all of my utilities (at least as many as I could automate)

Create the file `~/scripts/upgrade`\
Make it executable: `chmod +x ~/scripts/upgrade`\
Contents of the file:

```sh
#!/usr/bin/env bash
# Script to upgrade all of my system utilities

# Brew
brew update && brew upgrade && brew cleanup

# ZSH
"$ZSH/tools/upgrade.sh"

# Krew
kubectl krew upgrade

# App Store
mas update
```
