---
layout: image-right
image: /RetentionPolicy.jpg
---

# Retention Policy
- Eingebauter Mechanismus, um nicht getaggte Manifeste zu löschen
- Nur für Premium-Tier ACRs verfügbar

---
layout: image-right
image: /AcrTasks.jpg
---

# ACR Tasks
- [Automatisierungs-Layer innerhalb der Azure Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview)
- Vergleichbar mit DevOps Pipelines / GitHub Actions
- Images bauen, pushen, ausführen, testen, etc.
- [Task-Definitionen in YAML](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tasks-reference-yaml)
- Ausführung anhand von Triggern (z. B. Push oder Zeitplan)
- Es stehen Befehle zur Verfügung die über die Azure CLI nicht zur Verfügung stehen


---
layout: statement
---
# ACR Purge
[Löscht Images / Manifests anhand bestimmter Filter](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-auto-purge)

---

#  Verwaltung von Tasks

## Ad hoc ausführung
```powershell
az acr run -r thinkexception `
    --cmd 'acr purge --help' `
    /dev/null
```

## Anlegen
```powershell
az acr task create -n purgeTest -r thinkexception `
  --cmd 'acr purge --help' `
  -c /dev/null
```

## Anzeigen
```powershell
az acr task list -r thinkexception
az acr task show -n purgeTest -r thinkexception   
```

## Löschen

```powershell
az acr task delete -n purgeTest -r thinkexception
```


---

# Ausführung mit Schedule

## YAML-File mit Taskdefinition
```yaml
version: v1.1.0 # do not put this in your yaml file
steps: 
  - cmd: acr purge --filter '^.*:^[F|f]eature[-0-9]*$' --ago 30d --untagged --keep 1 --dry-run
    disableWorkingDirectoryOverride: true
    timeout: 3600
```

<br/>
<br/>

## Task aus dem YAML-File erstellen
```powershell
az acr task create -r thinkexception -n purgeFeatureImages `
    --file purgeFeatureImages.yaml `
    --schedule "0 1 * * Sun" `
    --context /dev/null
```    