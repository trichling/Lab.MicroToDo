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

# Ein normales Docker-Image...

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 as base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 as build
WORKDIR /app
COPY Lab.MicroToDo.Frontend.Api/Lab.MicroToDo.Frontend.Api.csproj Lab.MicroToDo.Frontend.Api/
COPY Lab.MicroToDo.Frontend.Contracts/Lab.MicroToDo.Frontend.Contracts.csproj Lab.MicroToDo.Frontend.Contracts/

RUN dotnet restore "Lab.MicroToDo.Frontend.Api/Lab.MicroToDo.Frontend.Api.csproj"
COPY . .
RUN dotnet publish "Lab.MicroToDo.Frontend.Api/Lab.MicroToDo.Frontend.Api.csproj" -c Release -o /app/publish

FROM base as final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Lab.MicroToDo.Frontend.Api.dll"]
```

Docker Image bauen:
```bash
docker build -f Dockerfile -t thinkexception.azurecr.io/microtodo-frontendapi:dev-net8 .\..
```

---
layout: image-right
image: /Syft.png
---
# ... und was da drin ist

<v-clicks>

- um das herauszufinden, gibt es <a href="https://github.com/anchore/syft" target="_blank">syft</a>

```powershell
syft `
  thinkexception.azurecr.io/
    microtodo-frontendapi:dev-net8 
```

- und wie viel davon ist vom Betriebssystem?

- ratet mal... und bedenkt, dass es sich um ein Runtime-Image handelt - kein SDK-Image!

```powershell
syft thinkexception.azurecr.io/
    microtodo-frontendapi:dev-net8 `
        | sls "deb" ` 
        | measure
```

- Es sind <span v-click v-mark.red>94 Betriebssystempakete</span> (bitte merken!)

</v-clicks>

<!--
syft thinkexception.azurecr.io/microtodo-frontendapi:dev-net8

syft thinkexception.azurecr.io/microtodo-frontendapi:dev-net8 `
    | sls "deb" ` 
    | measure
-->
---
layout: image-right
image: /Grype.png
---
# Beißt der oder will der nur spielen?

<v-clicks>

- um das herauszufinden gibt es <a href="https://github.com/anchore/grype" target="_blank">grype</a>

```powershell
grype thinkexception.azurecr.io/
    microtodo-frontendapi:dev-net8
```

- und wie viel davon ist vom Betriebssystem mit Priorität High?

```powershell
grype thinkexception.azurecr.io/
    microtodo-frontendapi:dev-net8 `
    | sls deb `
    | sls High `
    | measure 
```

- Es sind <span v-click v-mark.red>3 Verwundbarkeiten</span> mit hoher dringlichkeit (bitte merken!)

</v-clicks>


<!--
grype thinkexception.azurecr.io/microtodo-frontendapi:dev-net8

grype thinkexception.azurecr.io/microtodo-frontendapi:dev-net8 `
    | sls deb `
    | sls High `
    | measure 
-->