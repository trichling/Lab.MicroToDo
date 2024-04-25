---
layout: image-right
image: /Announcement.jpg
---
# Chiseled Images to the rescue
- Microsoft kündigt [Chiseled Containers](https://devblogs.microsoft.com/dotnet/announcing-dotnet-chiseled-containers/) als GA an.
- Dise enthalten wesentlich weniger Abhängigkeiten und sind deshalb kleiner und sicherer
- Vergleichbar mit [Google Distroless](https://github.com/GoogleContainerTools/distroless)
- Werden aber vom upstream image provider (ubuntu) bereitgestellt
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
```

Docker Image bauen:
```bash
docker build -f Dockerfile -t thinkexception.azurecr.io/microtodo-frontendapi:dev-net8 .\..
```

```bash
syft thinkexception.azurecr.io/microtodo-frontendapi:net8-chiseled
syft thinkexception.azurecr.io/microtodo-frontendapi:net8-chiseled | grep deb | wc -l

grype thinkexception.azurecr.io/microtodo-frontendapi:net8-chiseled
grype thinkexception.azurecr.io/microtodo-frontendapi:net8-chiseled | grep deb | wc -l
```

<!-- 
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep thinkexception.azurecr.io/microtodo-frontendap -->

---

# Wie machen die das?

## So (runtime/8.0/jammy-chiseled):
```dockerfile {3-4|1,6-7|none}
ARG REPO=mcr.microsoft.com/dotnet/runtime-deps

# Installer image
FROM arm64v8/buildpack-deps:jammy-curl AS installer 

# .NET runtime image
FROM $REPO:8.0.4-jammy-chiseled-arm64v8

```
<v-click>

## Und so (runtime-deps/8.0/jammy-chiseled):

```dockerfile {1-3|5|7-9}
# Use chisel tool from canonical to trim down image after installing stuff
FROM arm64v8/golang:1.20 as chisel
RUN go install github.com/canonical/chisel/cmd/chisel@v0.9.0 \

# Cut down the image (using a conveinience tool around chisel named chisel-wrapper)

FROM scratch
# Copy over the minimum amount of things (i. e. the file system)
COPY --from=chisel /rootfs /

```
</v-click>

<v-click>

Was ist eigentlich dieses scratch? [[1]](https://docs.docker.com/build/building/base-images/) [[2]](https://www.howtogeek.com/devops/how-to-create-your-own-docker-base-images-from-scratch/)

</v-click>
<!--
https://github.com/dotnet/dotnet-docker/blob/main/src/runtime/8.0/jammy-chiseled/arm64v8/Dockerfile
https://github.com/dotnet/dotnet-docker/blob/main/src/runtime-deps/8.0/jammy-chiseled/arm64v8/Dockerfile
https://discourse.ubuntu.com/t/container-images-that-rock-rocks-manifesto/32091
https://github.com/canonical/rocks-toolbox
-->
