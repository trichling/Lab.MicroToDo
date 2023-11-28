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
hideInToc: true
---

# The journey map
<img src="/JourneyMap.png" class="w-full max-w-lg max-h-lg mx-auto rounded shadow" />

---
layout: section
background: /JourneyMap.png
---

# Are we services, and if so how many?
What does Microservice Architecture mean to us?
---
---
# For example RateMyBeer

<img src="/DemoApp.png" class="w-full max-w-md max-h-md mx-auto rounded shadow" />

<p v-click style="text-align: right">But we will do something a lot simpler</p>

<!--
Not necessarily "micro" but self contained
-->

---
layout: section
background: /JourneyMap.png
---

# Works on my machine - lets ship my machine
Dockerize your application

---
src: /pages/container.md
---

---
layout: section
background: /JourneyMap.png
---

# Spin up a cluster - or more
Bring your cluster up

---
src: /pages/kubernetes.md
---

---
layout: section
background: /JourneyMap.png
---

# Show the world what you've got
Allow incoming HTTP traffic through an ingress controller

---
src: /pages/ingress.md
---

---
layout: section
background: /JourneyMap.png
---

# But do it securely
Encrypt your traffic wiht lets-encrypt and cert-manager

---
src: /pages/ssl.md
---

---
layout: section
background: /JourneyMap.png
---

# Who am I and what can I do?
Identity management and ressource access with managed Identites 

---
src: /pages/identity.md
---

---
layout: section
background: /JourneyMap.png
---

# Watch my steps
Monitoring your cluster with prometheus and grafana

---
src: /pages/monitoring.md
---

---
layout: section
background: /JourneyMap.png
---

# Up and down it goes
Automatic scaling with node and pod autoscaling

---
src: /pages/scaling.md
---

---
layout: section
background: /JourneyMap.png
---

# Bring some chaos into the order
Conduct controlled chaos experiments with chaos-mesh

---
src: /pages/chaos.md
---

---
layout: section
background: /JourneyMap.png
---

# Smash the bugs
Debug your application and attach to an existing pod

---
src: /pages/debugging.md
---