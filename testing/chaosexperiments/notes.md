# Installation
- See chaos dashboard (portforward)

# Permissions
- rbac-default-manager.yaml
- Getting a token


# Chaos Experiments 
## Via UI

- Memory (OOMKill) [stress-test-memory.yaml]
- CPU (HPA) [stress-test-cpu.yaml]
- Network Latency - Where to see this?? [network-delay.yaml]
- Network Loss - Where to see this?? [network-loss.yaml]
- High CPU in ingress-nginx - warte: ich sehe die pods nicht? [stress-test-cpu-ingress-nginx.yaml]
  => UI-Token nur auf namespace-ebene! 

## Via yaml
- ingress-nginx high cpu per yaml - das geht, aber ich sehe es nicht in der UI
- Wir brauchen ein Cluster-Scope-Token für die UI um das zu sehen
  => rbac-cluster-manager.yaml, token holen, in ui umloggen

- auch andere Experimente gehen
- management über die crds

# Schedules
- pod-failure jede minute => crash loop backoff

# Workflows
