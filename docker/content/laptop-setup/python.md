---
title: 'Python'
draft: false
series: ["Laptop Setup"]
---

This guide details how I configured my laptop in order to work with [Python](https://www.python.org/).

First install Python:

```sh
brew install python
```

Or a specific version:

```sh
brew install python@<version>
```

Then call on it using `python3`.

For using a specific version installed via Brew, edit `.zshrc`:

```sh
export PATH="$(brew --prefix)/opt/python@<version>/libexec/bin:$PATH"
```

Then restart your shell.

## VSCode

I installed the following extension to easily use Python in VSCode:

- [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)

## Ruff

I prefer to use the Ruff linter:

```sh
brew install ruff
```

Then configure VSCode to use it with the official extension:

- [Ruff](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff)

I also prefer for Ruff to lint my Python scripts on-save. This can be done by editing the `settings.json` file in VSCode (Command + Shift + P -> `Preferences: Open User Settings (JSON)`) and adding the following:

```json
{
  "[python]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "charliermarsh.ruff"
  }
}
```
