---
layout: two-cols
---

# API Containers

Standard .NET Api

```dockerfile
# Build is done with dotnet SDK
FROM mcr.microsoft.com/dotnet/sdk:7.0 as build

# Final image is aspnet runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0 as final







# Run dotnet
ENTRYPOINT ["dotnet", "Lab.MicroToDo.Frontend.Api.dll"]
```
::right::

# SPA Container

Nginx with special handling for Blazor and Env Vars

```dockerfile
# Build is done with dotnet SDK
FROM mcr.microsoft.com/dotnet/sdk:7.0 as build

# Final image is nginx (serving just static files)
FROM nginx:alpine as final

# Include specific headers for Blazor configuration
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Replace environemnt vars in source code
COPY entrypoint.sh /docker-entrypoint.d/40-env-vars.sh

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
```