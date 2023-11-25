---
layout: center
---
# Some basics about Kubernetes
very few, if needed?

---
layout: two-cols
---

# Architektur

<img src="/KubernetesArchitektur.png" class="p-4 w-full max-w-lg max-h-lg mx-auto rounded shadow" />

::right::

# Api Objects

<img src="/KubernetesApiObjects.png" class="p-4 w-full max-w-lg max-h-lg mx-auto rounded shadow" />


---
layout: center
---
# How hard can it be?
az aks create

---

# Maybe a littel bit harder

> How many environments do you have?

Do you have a development, staging and production environment? Or do you got fully trunk based?

> How many applications do you have?

Will you host just a single application or multiple applications? In case of multiple applications you want to seperate the networks.

> How many clusters do you have?

Do you have a cluster per ticket? Per developer? Per environments?

---

# Assumptions

> We will assume that we have dev, stage and prod environments.


```powershell
10.[dev = 1 | stage = 2 | prod = 3].0.0/16
```

<br/>

> We will assume that we have multiple applications. 



```powershell
10.[ 1 | 2 | 3].[app1 = 0 - 3 | app2 = 4 - 7].0/22
```

<br/>

> We will also assume that we have multiple clusters per environment. 


```powershell
10.[ 1 | 2 | 3].[ 1 - 3 | 5 - 7 ].[cluster1 = 0 - 15 | cluster2 = 16 - 31]/28
```

Examples:
    
```powershell
10.1.4.0/22 # Seconde application in dev environment
10.1.4.16/28 # Sedcond cluster of second application in dev environment
```

---

# Decisions


> We will use kubenet networking for our clusters

Due to the fact that we wish to support a high number of clusters and we do not need the advanced features of Azure CNI we will use kubenet networking.


> Clusters will get numbers attached to their names

Even if the number of clusters is not that high we will attach numbers to the cluster names to make it easier to identify them.

> Naming convention for clusters will be


```powershell
aks-[app]-[env]-[number]
```
<!--
Demo:
    infrastructure/azure/basic.ps1
    infrastructure/azure/cluster.ps1
-->

---
layout: center
---
# How to bring the application to the cluster?
Helm, Kustomize, CDK8s, or whatever ...

---
layout: two-cols
---
# Helm

## Pros
- Can handle complex deployments
- Can publish charts to a repository

## Cons
- Additional tooling / learning curve
- Tends to be more complex than needed

<br />

> Geared towards deploying whole applications

:: right ::

# Kustomize

## Pros
- Part of kubectl
- Based on standard kubernetes manifests

## Cons
- Documentation is not that good
- Needs additional tooling for templating

<br />

> Geared towards deploying parts of applications

<!--
Demo: 
    infrastructure7kubernetes/sqlserver/deploy-feature.ps1

Explain base / overlay

Deploy application, explain .template / prepare-branch.ps1

# Application changes

## Client

- Set BLAZOR_ENVIRONMENT via deployment env vars (remember what we did in the dockerfile?)
- Inject URL to BFF via env var: `Dependencies__APIs__TodosApiBaseUrl`

## BFF

- Set ASPNETCORE_ENVIRONMENT via deployment env vars
- Inject URL to API via env var: `Dependencies__Apis__TodosApiBaseUrl`

## API

- Grab database password from secret `mssql-sapassword`

-->

---
layout: center
---
# Let's see it in action!
Your application, locked up into a cluster!


<!--
Per Port-Forward mit Pod verbinden
-->