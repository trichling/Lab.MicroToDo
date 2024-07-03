# Monitoring

- [Prometheus](https://prometheus.io/) is a monitoring system and time series database.

- [Grafana](https://grafana.com/) is a visualization tool for Prometheus.

- Azure integrations to both services exists, but they can be installed on AKS cluster as well.

- When on Azure there are natvie services that can be used instead of Prometheus and Grafana.

<!--

Crash loop backoff rule

KubeEvents 
| where ClusterName =~ '<cluster name>'
| where ObjectKind =~ 'Pod'
| where Reason =~ 'BackOff'
| project TimeGenerated, Name, ObjectKind, Reason, Message, Namespace, Count
| order by TimeGenerated desc
| summarize AggregatedValue=sum(Count) by bin(TimeGenerated, 5m) 

-->