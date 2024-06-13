# Was ist Chaos engineering

# Was braucht man
- Eine Chaos-Engine
- Monitoring!! Für alle Ebenen von Faults (mostly out of scope)
- Automatisierung / einen Plan
- Hypothese -> Experiement -> Analyse -> Verbesserung

# Welche Chaos Engines gibt es?
- Chaos Monkey
- Azure Chaos Studio
- Gremlin

# Installation
- See chaos dashboard (portforward)

# Permissions
- rbac-default-manager.yaml
- Getting a token


# Chaos Experiments 
## Via UI

- Memory (OOMKill)
- CPU (HPA)
- Network Latency - Where to see this??
- Network Loss - Where to see this??
- High CPU in ingress-nginx - warte: ich sehe die pods nicht?
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
