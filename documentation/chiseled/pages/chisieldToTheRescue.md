# Chiseled Images to the rescue
- Distroless (like [Google Distroless](https://github.com/GoogleContainerTools/distroless))
- Werden aber vom upstream image provider (ubuntu) bereitgestellt
- https://devblogs.microsoft.com/dotnet/announcing-dotnet-chiseled-containers/
- https://github.com/dotnet/dotnet-docker/blob/main/README.runtime.md
- https://github.com/dotnet/dotnet-docker/blob/main/documentation/ubuntu-chiseled.md

---

# Wie geht das?
https://github.com/dotnet/dotnet-docker/blob/main/src/runtime/8.0/jammy-chiseled/arm64v8/Dockerfile
https://github.com/dotnet/dotnet-docker/blob/main/src/runtime-deps/8.0/jammy-chiseled/arm64v8/Dockerfile

---

# Will ich haben!
- Dockerfile umbauen

```bash
syft thinkexception.azurecr.io/microtodo-frontendapi:net8-chiseled
syft thinkexception.azurecr.io/microtodo-frontendapi:net8-chiseled | grep deb | wc -l

grype thinkexception.azurecr.io/microtodo-frontendapi:net8-chiseled
grype thinkexception.azurecr.io/microtodo-frontendapi:net8-chiseled | grep deb | wc -l
```

<!-- docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep thinkexception.azurecr.io/microtodo-frontendap -->