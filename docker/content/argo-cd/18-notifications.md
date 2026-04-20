---
title: 'Notifications'
draft: false
weight: 18
series: ["Argo-CD"]
series_order: 18
---

ArgoCD notifications is a controller which provides a customizable mechanism to alert users about changes in the state of ArgoCD applications while continuously monitoring the applications. ArgoCD supports a wide range of notification services such as email, Telegram, webhook, Github, etc.

In this example we will be using Slack.

1. Get a Slack token with write permissions
1. Store the token in the `argocd-notifications-secret` ArgoCD secret

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: argocd-notifications-secret
    stringData:
      slack-token: xoxb-453183324538318-38394548381...
    ```

1. Now in the `argocd-notifications-cm` config map we define a couple of things:
    1. We reference the Slack token
    1. We specify the trigger (which defines the condition when the notification should be sent). The definition includes the name, condition, and the notification template reference
    1. We define a message template which will be written to Slack (message templates are designed to be reusable and can be referenced by multiple triggers)
    1. To add more details to the Slack message such as commit message, repoURL, author details, etc. we can make use of Slack attachments

    ```yaml
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: argocd-notifications-cm
    data:
      service.slack: |
        token: $slack-token
        username: argocd-bot
        icon: ":rocket:"
      trigger.on-sync-succeeded: |
        - when: app.status.sync.status == 'Synced'
          send: [app-sync-succeeded-slack]
      template.app-sync-succeeded-slack: |
        message: |
          Application {{.app.metadata.name}} sync is {{.app.status.sync.status}}.
        slack:
          attachments:
            [{
              "title": "{{ .app.metadata.name }}"
            }]
    ```

1. Then we need to patch the ArgoCD application or project with an annotation to enable notifications:

    ```yaml
    apiVersion: argoproj.io/v1alpha1
    kind: Application
    name: square-app
    namespace: argocd
    metadata:
      annotations:
        notifications.argoproj.io/subscribe.on-sync-succeeded.slack: ‹slack-channel>
    ```

> We can create our own custom triggers and templates, or use/modify ArgoCD's out-of-the-box notification catalog, which is a set of useful triggers and templates.
