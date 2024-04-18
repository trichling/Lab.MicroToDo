# Installation

```powershell
helm upgrade cert-manager jetstack/cert-manager --install `
    --namespace cert-manager `
    --set installCRDs=true

# Certificate Issuer for Let's Encrypt
# The issuer depend on the ingress class, so it is different for agic and nginx
kubectl apply -f letsencrypt-prod-http-issuer.yaml    
kubectl apply -f letsencrypt-staging-http-issuer.yaml    

```

---
layout: two-cols
---
# nginx

```yaml{3|9-12}
metadata:
  annotations:
    cert-manager.io/issuer: letsencrypt-staging-http-issuer

  name: microtodo-frontend-api
spec:
  ingressClassName: nginx

  tls:
  - hosts:
    - microtodo-dev-0.westeurope.cloudapp.azure.com
    secretName: microtodo-ssl

  rules:
  - host: microtodo-dev-0.westeurope.cloudapp.azure.com
    http:
      paths:
      - backend:
```

:: right ::

# agic


```yaml{0}
metadata:
  annotations:
    cert-manager.io/issuer: letsencrypt-staging-http-issuer

  name: microtodo-frontend-api
spec:
  ingressClassName: azure-application-gateway

  tls:
  - hosts:
    - microtodo-dev-0.westeurope.cloudapp.azure.com
    secretName: microtodo-ssl

  rules:
  - host: microtodo-dev-0.westeurope.cloudapp.azure.com
    http:
      paths:
      - backend:
```
