---
title: 'Kubernetes'
draft: false
series: ["Laptop Setup"]
---

This guide details how I configured my laptop in order to work with [Kubernetes](https://kubernetes.io/)

## Kubectl CLI

Install Kubectl:

```sh
brew install kubernetes-cli
```

### Aliases

Add [kubectl aliases](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl) in your `~/.zshrc` file by adding the following plugin:

```sh
plugins=(
  kubectl
)
```

### Terminal Context

Then configure zsh to show current Kubernetes context and namespace by using [kube-ps1](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kube-ps1)

Install kube-ps1:

```sh
brew install kube-ps1
```

In your `~/.zshrc` file add the following plugin:

```sh
plugins=(
  kube-ps1
)
```

### [KubeColor](https://kubecolor.github.io/)

Get colored output for kubectl commands

```sh
brew install kubecolor
```

Then alias the kubectl command to use kubecolor by adding the following line in your `~/.zshrc`:

```sh
alias kubectl=kubecolor
```

Make sure to instruct zsh to use kubectl shell completion for kubecolor (add in `~/.zshrc`)

```sh
# Use kubectl shell completion for kubecolor
compdef kubecolor=kubectl
```

## Plugins

There are many kubectl plugins that provide added functionality to the cli tool. The full list of available plugins can be seen [in this page](https://krew.sigs.k8s.io/plugins/)

Install the krew package manager:

```sh
brew install krew
```

Then add to `~/.zshrc`:

```sh
# Krew - The kubectl package manager
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
```

### [klock](https://github.com/applejag/kubectl-klock)

Adds watch functionality for Kubernetes resources

```sh
kubectl krew install klock
```

### [neat](https://github.com/itaysk/kubectl-neat)

Removes clutter from Kubernetes manifests

```sh
kubectl krew install neat
```

### [stern](https://github.com/stern/stern)

Tails logs from multiple pods with color coding

```sh
kubectl krew install stern
```

### [tree](https://github.com/ahmetb/kubectl-tree)

Creates an ownership tree for Kubernetes objects

```sh
kubectl krew install tree
```

### [ktop](https://github.com/vladimirvivien/ktop)

Like htop but for Lubernetes

```sh
kubectl krew install ktop
```

### [kubectl-view-allocations](https://github.com/davidB/kubectl-view-allocations)

Creates a resource usage tree from the node level to the pod level, by resource

```sh
kubectl krew install view-allocations
```

## Editing resources with VSCode

By default when running `kubectl edit` a vim instance will open. In my opinion using VSCode for this task is better

Set the KUBE_EDITOR environment variable in `~/.zshrc` to vim:

```sh
# Make kubectl use VSCode to edit resources
export KUBE_EDITOR='code --wait'
```

## Helm

Install:

```sh
brew install helm
```

Configure helm common aliases by adding this plugin your `~/.zshrc`:

```sh
plugins=(
  helm
)
```
