---
layout: image-right
---
# Retention Policy
- Eingebauter Mechanismus, um nicht getaggte Manifeste zu löschen
- Nur für Premium-Tier ACRs verfügbar
---
layout: image-right
---
# ACR Tasks
- [Automatisierungs-Layer innerhalb der Azure Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview)
- Vergleichbar mit DevOps Pipelines / GitHub Actions
- Images bauen, pushen, ausführen, testen, etc.
- [Task-Definitionen in YAML](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tasks-reference-yaml)
- Ausführung anhand von Triggern (z. B. Push oder Zeitplan)
- Es stehen Befehle zur Verfügung die über die Azure CLI nicht zur Verfügung stehen

---
# ACR Purge
- [Löscht Images / Manifests anhand bestimmter Filter](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-auto-purge)


- Ad-hoc-Ausführung von Tasks
```powershell
az acr run -r thinkexception `
    --cmd 'az acr purge --help' `
    /dev/null
```

- Ausführung mit Schedule 
```yaml
version: v1.1.0 # do not put this in your yaml file
steps: 
  - cmd: acr purge --filter '^.*:^[F|f]eature[-0-9]*$' --ago 30d --untagged --keep 1 --dry-run
    disableWorkingDirectoryOverride: true
    timeout: 3600
```

```powershell
az acr task create -r thinkexception -n purgeFeatureImages `
    --file purgeFeatureImages.yaml `
    --schedule "0 1 * * Sun" `
    --context /dev/null
```    