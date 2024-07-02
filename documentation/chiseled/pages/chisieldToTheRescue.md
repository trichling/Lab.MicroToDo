---
layout: image-right
image: /Announcement.jpg
---
# Chiseled Images to the rescue
- Microsoft kündigt [Chiseled Containers](https://devblogs.microsoft.com/dotnet/announcing-dotnet-chiseled-containers/) als GA an.
- Diese enthalten wesentlich weniger Abhängigkeiten und sind deshalb kleiner und sicherer
- Vergleichbar mit [Google Distroless](https://github.com/GoogleContainerTools/distroless)
- Werden aber vom Upstream Image Provider (ubuntu) bereitgestellt
- Microsoft stellt [Chiseled Images](https://github.com/dotnet/dotnet-docker/blob/main/documentation/ubuntu-chiseled.md
) für die runtime und aspnet bereit. 

---

# Will ich haben!

```dockerfile {monaco-diff}
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
~~~
FROM mcr.microsoft.com/dotnet/aspnet:8.0-jammy-chiseled as base
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
docker build -f Dockerfile -t thinkexception.azurecr.io/microtodo-frontendapi:dev-net8-chiseled .\..
```

Welche Images gibt es als Chiseled? [1](https://hub.docker.com/r/microsoft/dotnet-aspnet)

<!-- 
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep thinkexception.azurecr.io/microtodo-frontendap 
-->

---
layout: image-right
image: /SqueezeContainer.jpg
---
# Und was macht das mit dem Image?

## Syft

Statt 94 Paketen nur noch <span style="font-size: 27pt; color: red" v-click >9</span>

<v-click at="3">

## Grype

Statt 3 High-Vulnerabilities nur noch <span style="font-size: 27pt; color: red" v-click="5">0</span>

</v-click>

<v-click at="6">

## Size

Statt 223 MB nur noch <span style="font-size: 27pt; color: red" v-click="8">115 MB</span>

</v-click>

---
layout: statement
---

# Wie machen die das?

<v-click>

Was ist das kleinste Docker Base Image?

</v-click>

---
layout: quote
---

# FROM scratch

If you need to completely control the contents of your image, you can create your own base image from a Linux distribution of your choosing, or use the special `FROM scratch` base

<!--

Was ist eigentlich dieses scratch? [[1]](https://docs.docker.com/build/building/base-images/) [[2]](https://www.howtogeek.com/devops/how-to-create-your-own-docker-base-images-from-scratch/)

Jammy chiseled [[3]](https://github.com/dotnet/dotnet-docker/blob/main/src/runtime/8.0/jammy-chiseled/arm64v8/Dockerfile)

Jammy chiseled runtime deps [[4]](https://github.com/dotnet/dotnet-docker/blob/main/src/runtime-deps/8.0/jammy-chiseled/arm64v8/Dockerfile)

Rocks manifesto [[5]](https://discourse.ubuntu.com/t/container-images-that-rock-rocks-manifesto/32091)

Rocks toolbox [[6]](https://github.com/canonical/rocks-toolbox)

-->
