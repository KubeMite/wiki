---
title: 'Wiki CI'
draft: false
weight: 7
series: ["Homelab"]
series_order: 7
---

I use Github Actions for the CI of my [wiki](https://github.com/KubeMite/wiki) Docker image which contains my personal knowledge base and is my website, and the [wiki-helm](https://github.com/KubeMite/wiki-helm) Helm chart that contains everything that is needed to deploy that Docker image in Kubernetes.

The CI process is designed to be efficient by only building the Docker image once and promoting it as needed, and to provide quick feedback by ensuring common tests run quickly.

I decided to separate the Docker image from the Helm chart so that versions won't have to be incremented for both and new builds won't need to run for both while updating only one of them.

## Docker

These are the workflows for testing and building the Docker image

### [Tests](https://github.com/KubeMite/wiki/blob/main/.github/workflows/_tests.yaml)

I use a reusable workflow for quick tests that run for every commit to a side branch (not the main branch) and for every PR:

- test-hugo - making sure my markdown pages can successfully be compiled into HTML and CSS by [hugo](https://gohugo.io/)
- test-dockerfile - for making sure the Dockerfile I use to create the wiki Docker image works and follows best practices. This is done by [hadolint](https://hadolint.github.io/hadolint/)

### [Dev](https://github.com/KubeMite/wiki/blob/main/.github/workflows/dev.yaml)

This workflow runs on every commit to a side branch (not the main branch) and just calls the tests workflow. It is used to easily group all dev workflow runs in Github actions.
It runs pretty quickly (about 10-20 seconds) since both tests run in parallel.

### [Pull-request](https://github.com/KubeMite/wiki/blob/main/.github/workflows/pull-request.yaml)

Once a pull request targeting the main branch is opened this workflow is run. It uses the following steps:

1. It runs the tests workflow
1. It then builds the wiki Docker image using the Dockerfile, and pushes it to the Github container registry of the wiki repo (for both amd64 and arm64, with SBOM and caching). It is tagged with the hash of the latest commit of the pull-request source branch
1. Then it runs a couple long tests (1-2 minutes) in parallel
    1. This test scans the Docker image with [trivy](https://github.com/aquasecurity/trivy-action) and uploads the scan results to the Github code scanning page
    1. This test starts the Docker image and runs a [ZAP baseline](https://github.com/marketplace/actions/zap-baseline-scan) scan on it. The scan results are attached as artifacts to the run, and any findings are automatically opened as issues in the repo

### [Prod](https://github.com/KubeMite/wiki/blob/main/.github/workflows/prod.yaml)

This workflow has two jobs running one after another: one for the docker image (called promote-image) and one for updating the image referenced in the helm chart (update-image-tag-in-helm).

No tests are being run in this stage since they must have run in the pull-request workflow in order for a merge to the main branch to be possible.

1. For the first job (promote image) this job uses [crane](https://github.com/google/go-containerregistry/blob/main/cmd/crane/doc/crane.md) in order to interact with Docker image tags in remote registries without needing to pull and push the Docker images.

    This job can run under two different conditions and can do the following under each condition:

    - When a pull request to main has been accepted (meaning a push to the main branch):

        1. The workflow will use the [gh CLI](https://cli.github.com/) to find the latest commit hash in the source branch that has been merged to the main branch at the time that the pull request was accepted, by finding all pull requests that ended up having the current commit hash and getting the commit hash of that pull request.
        1. This workflow will then tag the Docker image with the discovered commit hash as the latest image and will add the current commit hash. This means that the Docker image will have two commits attached, which is the side effect of using merge + squash strategy since a brand new commit is made in the target branch and the original commit does not exist in the target branch

    - When a new tag has been created:

        1. The workflow will add the new tag name as a tag to the Docker image with the tag of the commit hash that a tag is being created from

2. Then the second job (update-image-tag-in-helm) runs, but only if a new tag is being created and the first job ran successfully (since there is no reason to update the helm chart if the docker image for the specific tag doesn't exist).

    It works like this:

    It checks out the wiki-helm repo, gets its latest tag, increments its tag's minor version by one, changes its appVersion to the new docker image tag that triggered this job, and pushes the changes to the wiki-helm repo under the main branch with the incremented tag.

    This ensures that the new helm chart is created and published, and that no tests are ran since it is assumed that the chart structure must have passed the tests to be in the main branch, and that updating the appVersion wont change anything in the helm chart itself.

    In order to be able to push changes to the wiki-helm repository from a github runner in the wiki repository, I had to create a fine-grained PAT (personal access token) for the wiki-helm repo with only read and write permission to code. I stored that PAT as an organization secret and only allowed Github runner under the wiki repository access to it, then referenced it in the workflow file.

## Helm Chart

These are the workflows for testing and building the Helm chart

### [Tests](https://github.com/KubeMite/wiki-helm/blob/main/.github/workflows/_tests.yaml)

I use a reusable workflow for quick tests that run for every commit to a side branch (not the main branch) and for every PR:

- test-helm - lints the helm chart

### [Dev](https://github.com/KubeMite/wiki-helm/blob/main/.github/workflows/dev.yaml)

This workflow runs on every commit to a side branch (not the main branch) and just calls the tests workflow. It is used to easily group all dev workflow runs in Github actions.
It runs pretty quickly (about 10-20 seconds).

### [Pull-request](https://github.com/KubeMite/wiki-helm/blob/main/.github/workflows/pull-request.yaml)

Once a pull request targeting the main branch is opened, this workflow is triggered. It runs the following tests simultaneously:

1. It runs the same tests the Dev workflow used
1. It makes sure the chart can be installed successfully. This is done with the following steps:
    1. It installs the helm cli
    1. It creates a [KinD](https://kind.sigs.k8s.io/) cluster
    1. It installs the helm chart on the KinD cluster with the default values

### [Prod](https://github.com/KubeMite/wiki-helm/blob/main/.github/workflows/prod.yaml)

This workflow runs only on new tags that are created.

It packages the helm files and pushes them to a chart registry hosted under [github pages](https://docs.github.com/en/pages) with the new tag.

I decided to host my helm charts using Github pages and not using Github packages because when using Github packages there is no central `index.yaml` to list all of the helm charts. Since I deploy my wiki using ArgoCD I require a central `index.yaml` for the argo operator to automatically detect the latest version and pull it, which is not possible when publishing helm charts using Github packages.
