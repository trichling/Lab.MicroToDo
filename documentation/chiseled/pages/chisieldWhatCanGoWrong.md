# ... fragen Sie Ihren Arzt oder Apotheker

## [Chiseled Images haben](https://github.com/dotnet/dotnet-docker/blob/main/documentation/ubuntu-chiseled.md)

- keine Shell

- keinen Paketmanager

- keinen root-User

- nur die minimale Menge an Paketen, die für .NET-Apps benötigt werden

- keine Codepages (ICU) und Zeitzonen (TZData)

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

<v-click>

## DO: "Exec" form
    
```dockerfile
RUN ["dotnet", "--list-runtimes"]
ENTRYPOINT ["dotnet", "myapp.dll"]
CMD ["dotnet", "myapp.dll", "--", "args"]
```

</v-click>

---

# wget, apt und Co
## DONT: wget in der final stage
```dockerfile {5-8}
# build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build
...

# final stage/image
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-jammy-chiseled
RUN wget -O somefile.tar.gz <URL> \
   && tar -oxzf aspnetcore.tar.gz -C /somefile-extracted
```

<v-click>

## DO: wget in der build stage 

```dockerfile {1-4}
# build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build
RUN wget -O somefile.tar.gz <URL> \
    && tar -oxzf aspnetcore.tar.gz -C /somefile-extracted
...

# final stage/image
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-jammy-chiseled
...
```

</v-click>

---

# Ablage von Dateien

<br/>

## DONT: Schreiben in das Verzeichniss der Applikation

```csharp
File.WriteAllLines("myFile.txt", myText);
```

<br/>

<v-click>

## DO: Dateien im Benutzerprofil ablegen
```csharp
var path = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), "myFile.txt");
File.WriteAllLines(path, myText);
```

</v-click>

---


# Globalisierung und Zeitzonen

- Z. B. Microsoft.SqlClient benötigt Globalization support für die Konvertierung von Unicode in andere Zeichensätze [[1]](https://github.com/dotnet/dotnet-docker/issues/5014)

- Dies verursacht eine Abhängigkeit auf ICU APIs [[2]](https://learn.microsoft.com/en-us/windows/win32/intl/international-components-for-unicode--icu-) [[3]](https://icu.unicode.org/)

- Für die Konvertierung von Datum und Uhrzeit werden auch Zeitonendaten benötigt (TZData) [[4]](https://www.iana.org/time-zones)

<v-click>

# DO - In case you need it

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0-jammy-chiseled-extra as base
```

Dockerfile [[5]](https://github.com/dotnet/dotnet-docker/blob/da5a045dc5dc64d18c8177fadb493da1c86982dc/src/runtime-deps/8.0/jammy-chiseled-extra/amd64/Dockerfile#L27-L39)

</v-click>