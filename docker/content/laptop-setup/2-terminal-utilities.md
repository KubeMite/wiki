---
title: 'Terminal Utilities'
draft: false
weight: 2
series: ["Laptop Setup"]
series_order: 2
---

These are utilities that enhance the terminal experience

## ITerm2

A better terminal emulator for MacOS

Download from here: [https://iterm2.com/downloads.html](https://iterm2.com/downloads.html)

## oh-my-zsh

An open-source framework for managing ZSH configuration

Download from here: [https://ohmyz.sh/#install](https://ohmyz.sh/#install)

## PowerLevel10K

A theme for ZSH that provides speed, new features and an overall better experience

```sh
brew install powerlevel10k
```

Source powerlevel10k so it can work:

```sh
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
```

A configuration wizard will run to configure your preferred terminal style and features.\
You can activate it at any time by running this command:

```sh
p10k configure
```

These are my configuration options:

1. Prompt Style - Rainbow
1. Character Set - Unicode
1. Show current time - No
1. Prompt Separators - Angled
1. Prompt Heads - Sharp
1. Prompt Tails - Flat
1. Prompt Height - Two lines
1. Prompt Connection - Dotted
1. Prompt Frame - Left
1. Connection & Frame Color - Lightest
1. Prompt Spacing - Sparse
1. Icons - Many icons
1. Prompt Flow - Concise
1. Enable Transient Prompt - Yes
1. Instant Prompt Mode - Verbose

## fzf

A fast command-line fuzzy finder

```sh
brew install fzf
```

Configure fzf's auto-completion and history search key bindings by adding this plugin to your `~/.zshrc`:

```sh
plugins=(
  fzf
)
```

## fzf-tab

Replaces zsh's default completion selection menu with fzf

```sh
brew install fzf-tab
```

Configure fzf-tab's auto-completion by adding this to your `~/.zshrc`:

```sh
source $(brew --prefix fzf-tab)/share/fzf-tab/fzf-tab.zsh
```

## zsh-syntax-highlighting

Highlights text in the terminal

```sh
brew install zsh-syntax-highlighting
```

Set zsh to use zsh-syntax-highlighting:

```sh
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```

Restart your shell

## zsh-autosuggestions

Suggests commands as you type based on history and completions

```sh
brew install zsh-autosuggestions
```

Set zsh to use zsh-autosuggestions:

```sh
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
```
