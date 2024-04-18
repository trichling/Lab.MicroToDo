# Dont use "Shell" form

```dockerfile
# "Exec" form - Works without a shell
RUN ["dotnet", "--list-runtimes"]
ENTRYPOINT ["dotnet", "myapp.dll"]
CMD ["dotnet", "myapp.dll", "--", "args"]

# "Shell" form - Doesn't work without a shell
RUN dotnet --list-runtimes
ENTRYPOINT dotnet myapp.dll
CMD dotnet myapp.dll -- args
```

---

# Use wget / apt etc in the build stage

```dockerfile	
# build stabe
FROM mcr.microsoft.com/dotnet/sdk:8.0-jammy AS build
...
RUN wget -O somefile.tar.gz <URL> \
    && tar -oxzf aspnetcore.tar.gz -C /somefile-extracted
...

# final stage/image
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0-jammy-chiseled
...
COPY --from=build /somefile-extracted .
```

---

# Write files to non-root user home dir

Dont
```
File.WriteAllLines("myFile.txt", myText);
```
Instead
```
string path = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), "myFile.txt");
File.WriteAllLines(path, myText);
```