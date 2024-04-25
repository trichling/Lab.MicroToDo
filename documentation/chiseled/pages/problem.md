---
layout: image-right
image: /DefenderForCloud.jpg
---
# Probleme erkennen

<v-clicks>

<a href="https://portal.azure.com/#view/Microsoft_Azure_Security/SecurityMenuBlade/~/EnvironmentSettings" target="_blank">

- Microsoft Defender For Cloud (oder ähnliches) aktivieren

</a>

- Neue Images pushen

- Ein bisschen warten

</v-clicks>

---
layout: image-right
image: /DefenderForCloud-ContainerRegistry.jpg
---
# Probleme erkennen

<v-clicks depth="2">

- Zur Container Registry gehen

- Alerts anschauen (speziell die für Container Images)

- Diese unterteilen sich in 2 große Kategorien

    - Betriebssystem Pakete (z. B. deb)
    
    - Anwendungspakete (z. B. NuGet)

</v-clicks>

---

# Woher kommen diese Verwundbarkeiten?

## Ein ganz normales Dockerfile


---

# und was da so alles drin ist...

```bash
syft thinkexception.azurecr.io/microtodo-frontendapi:net8
syft thinkexception.azurecr.io/microtodo-frontendapi:net8 | grep deb | wc -l
```

---

# Ist das gefährlich?

```bash
grype thinkexception.azurecr.io/microtodo-frontendapi:net8
grype thinkexception.azurecr.io/microtodo-frontendapi:net8 | grep deb | wc -l
```