# Quetions

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

