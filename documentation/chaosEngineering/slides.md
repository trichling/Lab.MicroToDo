---
# try also 'default' to start simple
theme: dracula
# random image from a curated Unsplash collection by Anthony
# like them? see https://unsplash.com/collections/94734566/slidev
background: /Chaos.jpg
# some information about your slides, markdown enabled
title: Chaos Engineering
layout: cover
---

# Bring ein bisschen Chaos in die Ordnung!

Chaos Engineering mit Chaos Mesh in Kubernetes
---
layout: author
---

![image of trichling](/TobiFace.jpg)


# Tobias Richling

Teamleiter Digital Operations @ apetito AG
Passionate about .NET, Docker, Kubernetes and Software Architecture

<footer >

<iconoir-twitter /> [@trichling](https://twitter.com/trichling)
<iconoir-github /> [trichling](https://github.com/trichling)
<iconoir-mail /> [tobias.richling@apetito.de](mailto:tobias.richling@apetito.de)

</footer>

---
layout: image-right
image: /Chaos.jpg
---
# Agenda

- Ja wieso denn bloß?

- Was ist Chaos Engineering

- Chaos Engineering mit Chaos Mesh
    - Installation
    - Chaos Experimente
    - Schedules
    - Workflows

- Dev, Stage, Prod?

- Fazit und Ausblick

---
layout: section
---

# Ja wieso denn bloß?

---
layout: image-left
image: /Fallacies.jpg
---

# Fallacies of distributed computing 

1. The network is reliable. <span style="font-size: x-small">(Das Netzwerk ist ausfallsicher.)</span>
2. There is zero latency. <span style="font-size: x-small">(Die Latenzzeit ist gleich null.)</span>
3. Bandwidth is infinite. <span style="font-size: x-small">(Der Datendurchsatz ist unbegrenzt.)</span>
4. The network is secure. <span style="font-size: x-small">(Das Netzwerk ist sicher.)</span>
5. Topology never changes. <span style="font-size: x-small">(Die Netzwerktopologie ist stabil.)</span>
6. There is one admin. <span style="font-size: x-small">(Es gibt nur einen Administrator.)</span>
7. Transport cost is zero. <span style="font-size: x-small">(Der Datentransports kostet nichts.)</span>
8. The network is <br/> homogeneous. <span style="font-size: x-small">(Das Netzwerk ist homogen.)</span>

<p style="text-align: end">

[Quelle: Wikipedia](https://en.wikipedia.org/wiki/Fallacies_of_distributed_computing)

</p>

---
layout: section
---

# Was ist Chaos Engineering

---
layout: quote
---

# Chaos Engineering is the discipline of <span v-mark.red>experimenting</span> on a system in order to build <span v-mark.red>confidence</span> in the system’s capability to <span v-mark.red>withstand</span> turbulent conditions in production.

[Quelle: Principle of chaos engineering](https://principlesofchaos.org/)


---

# Prozess des Chaos Engineering

<div style="margin: auto;width: 50%">
```mermaid { scale: 1.8 }
graph TD;
 
    A[Hypothese] === B[Verbesserung];
 
    A === C[Experiment];
 
    B === D[Analyse];
 
    C === D;

```
</div>

---

# Was braucht man für Chaos Engineering

<div style="margin: auto;width: 50%">
```mermaid { scale: 1.5 }
graph TD;
 
    A[Hypothese =<br/>Einen Plan] === B[Verbesserung = <br/> Ressourcen];
 
    A === C[Experiement = <br/>eine Chaos Engine];
 
    B === D[Analyse = <br/> Monitoring];
 
    C === D;

```
</div>

---
layout: statement
---

# Welche Möglichkeiten gibt es denn, ein bisschen Chaos zu erzeugen?

<v-click>
Gibt es da auch was von der Stange?
</v-click>

---
layout: image-right
image: /ChaosEngine.jpg
---

# Ein paar Chaos Engines...

- [Chaos Monkey](https://github.com/Netflix/chaosmonkey?tab=readme-ov-file)
    - entwickelt von Netflix
    - erfordert Spinnaker und eine MySQL Datenbank
- [Azure Chaos Studio](https://learn.microsoft.com/en-us/azure/chaos-studio/chaos-studio-overview)
    - CAAS (Chaos as a Service)
    - Erfordert eine Azure Subscription
- [Gremlin ](https://www.gremlin.com/)
    - CAAS (Chaos as a Service)
    - Cloud-Unabhängig
- [Chaos Mesh](https://chaos-mesh.org/) / [Litmus](https://litmuschaos.io/)
    - Kostenlos
    - Open Source

---

# Chaos-Mesh

<v-clicks>

- Chaos-Mesh ist eine cloud-native Chaos Engineering Plattform, die Chaos in Kubernetes-Umgebungen orchestriert.

- Chaos-Mesh wurde im Juli 2020 von der CNCF akzeptiert.

- Chaos-Mesh erreichte im Februar 2022 den Reifegrad "Incubating".

- Es ermöglicht das Injizieren von Fehlern in Kubernetes-Anwendungen, um die Widerstandsfähigkeit des Systems zu testen.

- Es ist einfach zu bedienen und bietet eine Web-Benutzeroberfläche zur Konfiguration und Verwaltung der Chaos-Experimente.

- Chaos-Experimente können sowohl als Kubernetes CRDs als auch über die Web-Benutzeroberfläche eingereicht werden.

</v-clicks>

---
layout: section
---

# Chaos Experimente!

---
layout: section
---

# Dev, Stage, Prod
Chaos Engineering in verschiedenen Umgebungen

---
layout: quote
---

# To guarantee both <span v-mark.red>authenticity</span> of the way in which the system is exercised and <span v-mark.red>relevance</span> to the current deployed system, Chaos strongly prefers to experiment directly on <span v-mark.red>production traffic</span>.

[Quelle: Principle of chaos engineering](https://principlesofchaos.org/)

---
layout: quote
---

# Experimenting in production has the potential to cause unnecessary <span v-mark.red>customer pain</span>. [...], it is the responsibility and obligation of the Chaos Engineer to ensure the <span v-mark.red>fallout [...] are minimized</span> and contained.

[Quelle: Principle of chaos engineering](https://principlesofchaos.org/)

---
# Ideen zum Umgang mit Chaos-Experimenten im Proudktivsystem

<v-clicks>

- Experimente zunächst in einer Testumgebung durchführen (klare Hypothese / Monitoring).

- Klare Beschränkung auf eng eingegrenzte Bereich (Blast-Radius).

- Klare Kommunikation innerhalb des Unterenhmens (interne Ankündigung).

- Den Kunden ein Wartung ankündigen, in der es zu Einschränkugen kommen kann (nicht zu oft).

- A/B Testing, Load Balancing auf einem parallelen System um nicht alle Kunden zu betreffen.

</v-clicks>
---
background: /Chaos.jpg
---

# Fazit

<v-clicks>

- Chaos Engineering leistet einen wichtigen Beitrag zur Entwicklung resilienter verteilter Systeme.

- Ohne gutes Monitoring und eine klare Hypothese sind Chaos Experimente wenig hilfreich.

- Chaos Mesh ist eine einfach zu bedienende und mächtige Chaos Engine für Kubernetes.

- Die Installation ist einfach weil es keine Abhängigkeiten gibt.

- Die Experimente sind einfach als Kubernetes Manifeste zu konfigurieren.

- Chaos Experimtente können in der Version Control verwaltet werden.

- Für weiterführende Experimente in mehreren Clustern oder mit mehreren Beteiligten wird Chaos Mesh irgendwann zu klein.

</v-clicks>

---
background: /ChaosFazit.jpg
# some information about your slides, markdown enabled
title: Chaos Engineering
layout: cover
---

# Vielen Dank für die Aufmerksamkeit!

Habt ihr noch Fragen?

<div absolute bottom-5 right-0 left-0 text-center fw300>

<iconoir-twitter /> [@trichling](https://twitter.com/trichling)   · 

<iconoir-github /> [trichling](https://github.com/trichling) ·  

<iconoir-mail /> [tobias.richling@apetito.de](mailto:tobias.richling@apetito.de)


</div>
