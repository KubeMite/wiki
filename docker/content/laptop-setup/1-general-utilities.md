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

## [Vorssaint](https://github.com/vorssaint/vorssaint-utils)

One menu bar icon doing the job of a dozen paid Mac apps.
Free, open source, and local-first.

```sh
brew install --cask vorssaint
```

Configs (in Vorssaint settings):

- General:
  - Enable **Launch at login**.
  - Appearance: System.
- Features (enable the following):
  - Maximize windows.
  - Window layout.
  - Quit on close.
  - Cut & paste.
  - Volume mixer.
  - Music app blocker.
  - Displays.
  - Extra brightness.
  - Copy text from screen.
  - Media.
  - Cleaner.
  - Uninstaller.
  - Homebrew.
  - App updates.
  - Screenshot.
  - Scratchpad.
  - Command bar.
  - Port manager.
  - Everything under System monitor.
- Volume mixer -> Options -> Enable **Use finer volume steps**.
- Displays -> More options -> Enable **Brightness keys follow the pointer** & **Show brightness when adjusting**.
- App updates:
  - Check in the background: Every day.
- Screenshot:
  - More options -> Enable **Start selection with the magnifier on**.
  - Temporary links -> Disable **Allow temporary links**.
- Scratchpad -> Enable **Global shortcut**.
- Command bar.
  - Enable **Global shortcut to open the bar**.
  - Shortcut: CMD + Space.
- Monitor:
  - Enable **CPU**, **CPU temperature**, **Memory**, and **Network**.
  - Enable **Pressure dot**.
  - Enable **Upload above download**.
  - Enable **Combine usage and temperature**.
  - Menu bar spacing: standard.
  - Enable **Hide the app icon while metrics are shown**.
- About.
  - Enable **Check for updates automatically**.

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

## [LocalSend](https://localsend.org/)

Send files wirelessly, securely, and privately

```sh
brew install --cask localsend
```

## [WhatCable](https://github.com/darrylmorley/whatcable)

Displays USB-C cable info for cables plugged into the Mac device.

```sh
brew install --cask darrylmorley/whatcable/whatcable
```

Then disable the pro hint at the end of plain text output of the CLI:

```sh
whatcable --silence-pro-hints
```
