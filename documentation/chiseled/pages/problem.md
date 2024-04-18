# Ein Blick in die Container Registry

---

# Ein ganz normales Dockerfile

---

# und was da so alles drin ist...

```bash
syft thinkexception.azurecr.io/microtodo-frontendapi:net8
syft thinkexception.azurecr.io/microtodo-frontendapi:net8 | grep deb | wc -l
```

---

# Ist das gefährlich?

```bash
grype thinkexception.azurecr.io/microtodo-frontendapi:net8
grype thinkexception.azurecr.io/microtodo-frontendapi:net8 | grep deb | wc -l
```