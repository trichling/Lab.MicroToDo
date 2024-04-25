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

# Nicht die "Shell" sondern die "Exec" Form verwenden


# NO: "Shell" form

```dockerfile
RUN dotnet --list-runtimes
ENTRYPOINT dotnet myapp.dll
CMD dotnet myapp.dll -- args
```

<br/>
<br/>
<br/>

# YES: "Exec" form
    
```dockerfile
RUN ["dotnet", "--list-runtimes"]
ENTRYPOINT ["dotnet", "myapp.dll"]
CMD ["dotnet", "myapp.dll", "--", "args"]
```

---

# wget, apt und co gehören in die build stage

```dockerfile {3-5|9-11|12-15}	
# build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build
...
RUN wget -O somefile.tar.gz <URL> \
    && tar -oxzf aspnetcore.tar.gz -C /somefile-extracted
...

# final stage/image
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-jammy-chiseled
...
COPY --from=build /somefile-extracted .

# This wont work! 
# RUN wget -O somefile.tar.gz <URL> \
#    && tar -oxzf aspnetcore.tar.gz -C /somefile-extracted
```

---

# Dateien müssen in ein Verzeichnis ohne root-Rechte geschrieben werden

### Das ist überlicherweise nicht das Verzeichnis wo die app installiert ist!!

<br/>

## Das klappt nicht
```
File.WriteAllLines("myFile.txt", myText);
```

<br/>

## Das schon
```
string path = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), "myFile.txt");
File.WriteAllLines(path, myText);
```