---
title: 'General Utilities'
draft: false
weight: 1
series: ["Laptop Setup"]
series_order: 1
---

These are general utilities I use in my day-to-day

## [PDFGear](https://www.pdfgear.com/)

Free local PDF editor

Download [from the app store](https://apps.apple.com/us/app/pdfgear-pdf-editor-reader/id6469021132)

## [Windows](https://www.microsoft.com/) App

Remotely connect to Windows machines

Download [from the app store](https://apps.apple.com/us/app/windows-app/id1295203466)

## [Bitwarden](https://bitwarden.com/)

Password manager

Download from the [app store](https://apps.apple.com/us/app/bitwarden-password-manager/id1137397744)

While it can be downloaded using `brew`, in order to use fingerprint unlock and biometric authentication with the Bitwarden chrome extension it must be downloaded from the app store

## [Homebrew](https://brew.sh/)

MacOS package manager

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## [Watch](https://en.wikipedia.org/wiki/Watch_(command))

Runs a specified command repeatedly

```sh
brew install watch
```

## [AWS CLI](https://aws.amazon.com/cli/)

Interacts with S3 buckets, and general AWS services

```sh
brew install awscli
```

## [Rectangle](https://rectangleapp.com/)

Provides window snapping and resizing, and keyboard shortcuts to move and resize windows

```sh
brew install --cask rectangle
```

To ensure that windows take their full available space, set the following settings:

- Gaps between windows - 0 px
- Stage manager recent apps area - 0px

Also set:

- Launch on login
- Check for updates automatically

## [ripgrep](https://ripgrep.org/)

Like grep, but faster

```sh
brew install ripgrep
```

## [dua-cli](https://github.com/byron/dua-cli)

Fast disk usage analyzer

```sh
brew install dua-cli
```

## [rsync](https://rsync.samba.org/)

Fast and versatile file copy utility

```sh
brew install rsync
```

## [yq](https://github.com/mikefarah/yq)

Yaml processor

```sh
brew install yq
```

## [eza](https://github.com/eza-community/eza)

A modern replacement for ls

```sh
brew install eza
```

Alias ls to use eza by adding this plugin in your `~/.zshrc`:

```sh
plugins=(
  eza
)
```

## [htop](https://htop.dev/)

Interactive process viewer

```sh
brew install htop
```

## [alt-tab](https://alt-tab.app/)

Windows-like alt-tab

```sh
brew install --cask alt-tab
```

## [Ice](https://icemenubar.app/)

Menu bar manager

```sh
brew install --cask jordanbaird-ice
```

## [Obsidian](https://obsidian.md/)

Knowledge base that works on top of a local folder of plain text Markdown files

```sh
brew install --cask obsidian
```

## [visual-studio-code](https://code.visualstudio.com/)

Open-source code editor & IDE

```sh
brew install --cask visual-studio-code
```

## [TailScale](https://tailscale.com/)

Managed ZTNA over WireGuard

```sh
brew install tailscale
brew install --cask tailscale-app
```

Add CLI completion:

```sh
tailscale completion zsh > "${fpath[1]}/_tailscale"
```

## [SendKeys](https://github.com/socsieng/sendkeys)

CLI to to automate keystrokes and mouse events

```sh
brew install socsieng/tap/sendkeys
```

## [Cilium CLI](https://cilium.io/)

CLI to interact with a Kubernetes cluster using the Cilium CNI

```sh
brew install cilium-cli
```

## [mas](https://github.com/mas-cli/mas)

Mac App Store command-line interface

```sh
brew install mas
```
