---
layout: center
---
# Which ingress controller should I use?
ingress-nginx, nginx-ingress, application-gateway-ingress, 

voyager, traefik, contour, skipper, kong, gloo, 

...

---
layout: two-cols
---

# ingress-nginx

## Pros
- The most popular ingress controller (maybe)
- Provided by the Kubernetes community
- Runs inside the cluster (self contained)

## Cons
- Provides no additional security features
- Can be difficult to configure / troubleshoot

<br />

> A good choice to start with for experimentation

:: right ::
# agic

## Pros
- App Gw has a lot of security features
- Provided by Microsoft
- Well integrated with Azure

## Cons
- Runs outside the cluster (external dependency)
- Can be difficutl to configure / troubleshoot

<br />

> A good choice when on Azure

---
layout: center
---
# Installation
ingress-nginx or agic

---
layout: two-cols
---

# nginx

```powershell
# Install via helm
helm install ingress-nginx ingress-nginx/ingress-nginx 

# Find automatically created public IP 
az network public-ip update -n $ingressIpName --dns-name 

# Create ingress class
kubectl apply -f ingress-class.yaml

# Create configuration
kubectl apply -f configmap-ingress-nginx-headers.yaml
```

:: right ::

# agic
```powershell
# public ip for application gateway
az network public-ip create ...

# create subnet
az network vnet subnet create

# Create application gateway
az network application-gateway create

# Enable in cluster
az aks enable-addons -a ingress-appgw
```


---
layout: center
---
# Usage
ingress-nginx or agic

---
layout: two-cols
---

# nginx
```yaml{5-8|11|18}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/use-regex: "true"

  name: microtodo-frontend-api
spec:
  ingressClassName: nginx

  rules:
  - host: microtodo-dev-0.westeurope.cloudapp.azure.com
    http:
      paths:
      - backend:
        path: /api(/|$)(.*)
        pathType: ImplementationSpecific
         


```


:: right ::

# agic
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    appgw.ingress.kubernetes.io/backend-path-prefix: /
    appgw.ingress.kubernetes.io/health-probe-path: /swagger


  name: microtodo-frontend-api
spec:
  ingressClassName: azure-application-gateway

  rules:
  - host: microtodo-dev-0.westeurope.cloudapp.azure.com
    http:
      paths:
      - backend:
        path: /api/*
        pathType: ImplementationSpecific
         
```

