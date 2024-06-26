# Install the remote debugger

```dockerfile {4-7|9-15|17-22,1-2}
FROM mcr.microsoft.com/dotnet/aspnet:7.0 as base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 as build
ARG CONFIG
RUN wget https://aka.ms/getvsdbgsh -O - 2>/dev/null | /bin/sh /dev/stdin -v latest -l ~/vsdbg
RUN apt-get update && apt-get -y install procps

# target this image for development builds (including remote debugger)
# docker build --target publish --build-arg CONFIG=Debug ...
FROM build AS publish
WORKDIR /application/frontend/src/Lab.MicroToDo.Frontend.Api
RUN dotnet publish "Lab.MicroToDo.Frontend.Api.csproj" -c  ${CONFIG} -o /app/publish
WORKDIR /app/publish
ENTRYPOINT ["dotnet", "Lab.MicroToDo.Frontend.Api.dll"]

# target this image for production builds (without remote debugger)
# docker build --build-arg CONFIG=Release ...
FROM base as final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Lab.MicroToDo.Frontend.Api.dll"]
```

---

# Attach to a pod

## launch.json

```json
{
    "name": "Attach Api (Kubernetes)",
    "type": "coreclr",
    "request": "attach",
    "pipeTransport": {
        "pipeProgram": "kubectl",
        "pipeArgs": [ "exec", "-i", "${command:extension.vsKubernetesSelectPod}", "--" ],
        "pipeCwd": "${workspaceRoot}",
        "debuggerPath": "/root/vsdbg/vsdbg",
        "quoteArgs": false
    },
    "sourceFileMap": {
        "/src": "${workspaceRoot}"
    }
}


https://github.com/OmniSharp/omnisharp-vscode/wiki/Attaching-to-remote-processes
https://github.com/vscode-kubernetes-tools/vscode-kubernetes-tools/blob/master/debug-on-kubernetes.md
```