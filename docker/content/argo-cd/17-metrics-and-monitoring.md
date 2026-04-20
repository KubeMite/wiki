---
title: 'Metrics & Monitoring'
draft: false
weight: 17
series: ["Argo-CD"]
series_order: 17
---

ArgoCD supports Prometheus metrics and alerts natively

## Scraping

ArgoCD exposes different sets of Prometheus metrics.

We will use the Prometheus operator, which uses Kubernetes custom resources to simplify the deployment and configuration of Prometheus, AlertManager, Grafana, and other related monitoring components.

We can read the scrape interval, the rules file and the scrape configuration by reading the environment yaml file in the config-reloader pod:

```sh
kubectl exec -it prometheus-0 -c config-reloader -- /bin/sh -c "cat /etc/prometheus/config_out/prometheus.env.yaml"
```

We can configure Prometheus to scrape ArgoCD metrics by using the service/pod monitoring CRD to perform auto-discovery and auto-configuration of scraping targets.

For service monitoring, the following steps are required:

1. Have actual services which expose metrics at a defined endpoint and port, and are identified with the appropriate label
    1. ArgoCD out-of-the-box exposes several services that expose Prometheus metrics:
        1. argocd-repo-server
        1. argocd-metrics
        1. argocd-applicationset-controller
        1. argocd-server-metrics
1. Create a serviceMonitor custom resource to discover the services based on matching labels
    1. ArgoCD provides a sample serviceMonitor manifest which can be applied on the Kubernetes server

        ```sh
        kubectl get servicemonitor argocd-server-metrics -o yaml
        ```

1. The operator uses the Prometheus CRD to match the serviceMonitors based on labels and generates the configuration for Prometheus
1. The Prometheus operator calls the ConfigReloader component to automatically update the configuration YAML with ArgoCD scraping target details
1. Then we can visualize those metrics using a Grafana dashboard

## Alerting

AlertManager handles alerts sent by client applications such as the Prometheus server.

PrometheusRule is a custom resource that defines recording and alerting rules for a Prometheus instance.\
Each rule has a name, trigger, duration, annotation, and label.

For example:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  creationTimestamp: null
  labels:
    prometheus: example
    role: alert-rules
  name: prometheus-argocd-rules
spec:
  - name: ArgoCD Rules
    rules:
      - alert: ArgoApplicationOutOfSync
        expr: argocd_app_info{sync_status="OutOfSync"} == 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "'{{ labels. name }}' Application has synchronization issue"
```

Once the Prometheus rule is created, the Prometheus operator uses the PrometheusRule CRD to generate the configuration for Prometheus.\
The Prometheus operator calls the config-reloader component to automatically update the rules file. Then the alerting rules should be added as part of the rules file and should be available when we go to the Rules tab in the Prometheus UI.\
An alert should be triggered and visible in the AlertManager UI if any ArgoCD application's sync status is out of sync.
