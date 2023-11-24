---
theme: the-unnamed
hideInToc: true
layout: cover
---


# A journey to Kubernetes

From local to cluster in ten easy steps
---
hideInToc: true
layout: about-me

helloMsg: Hello, I'm
name: Tobias Richling
imageSrc: /Tobi.jpg
job: Software Developer
line1: apetito AG
social1: '@trichling'
social2: tobias.richling@apetito.de

---
---
hideInToc: true
---

# The journey map
<img src="/JourneyMap.png" class="w-full max-w-lg max-h-lg mx-auto rounded shadow" />

---

# A demo application
<img src="/DemoApp.png" class="w-full max-w-lg max-h-lg mx-auto rounded shadow" />

---
layout: section
background: <image url or HEX or rbg or rgba> (optional)
---

# Dockerization

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
---

# Spin up a cluster - or more

---

# Show the world what you've got

---

# But do it securely

---

# Who am I and what can I do?

---

# Watch my steps

---

# Up and down it goes

---

# Bring some chaos into the order

---

# Smash the bugs