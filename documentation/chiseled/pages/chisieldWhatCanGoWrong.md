# ... fragen Sie Ihren Arzt oder Apotheker

## [Chiseled Images haben](https://github.com/dotnet/dotnet-docker/blob/main/documentation/ubuntu-chiseled.md)

- keine Shell

- keinen Paketmanager

- keinen root-User

- nur die minimale Menge an Paketen, die für .NET-Apps benötigt werden

<br/>
<br/>
<br/>

### Was muss man da beachten?

---

# "Shell" vs "Exec" Form


## DONT: "Shell" form

```dockerfile
RUN dotnet --list-runtimes
ENTRYPOINT dotnet myapp.dll
CMD dotnet myapp.dll -- args
```

<br/>
<br/>
<br/>

## DO: "Exec" form
    
```dockerfile
RUN ["dotnet", "--list-runtimes"]
ENTRYPOINT ["dotnet", "myapp.dll"]
CMD ["dotnet", "myapp.dll", "--", "args"]
```

---

# wget, apt und Co
## DONT: wget in der final stage
```dockerfile {7-8}
# build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build
...

# final stage/image
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-jammy-chiseled
RUN wget -O somefile.tar.gz <URL> \
   && tar -oxzf aspnetcore.tar.gz -C /somefile-extracted
```

## DO: wget in der build stage 

```dockerfile {3-4}
# build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build
RUN wget -O somefile.tar.gz <URL> \
    && tar -oxzf aspnetcore.tar.gz -C /somefile-extracted
...

# final stage/image
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-jammy-chiseled
...
```

---

# Ablage von Dateien

<br/>

## DONT: Schreiben in das Verzeichniss der Applikation

```csharp
File.WriteAllLines("myFile.txt", myText);
```

<br/>

## DO: Dateien im Benutzerprofil ablegen
```csharp
var path = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), "myFile.txt");
File.WriteAllLines(path, myText);
```
---
# Globalization / TZData

https://github.com/dotnet/dotnet-docker/issues/5014
https://github.com/dotnet/dotnet-docker/issues/5021