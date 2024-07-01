---
# try also 'default' to start simple
theme: dracula
# random image from a curated Unsplash collection by Anthony
# like them? see https://unsplash.com/collections/94734566/slidev
background: /DockerChiseled.jpg
# some information about your slides, markdown enabled
title: Chiseled to perfection
layout: cover
---

# Chiseled to perfection

Schlanke und Sichere Container-Images mit .NET bauen
---
layout: author
---

![image of trichling](/TobiFace.jpg)


# Tobias Richling

Teamleiter Digital Operations @ apetito AG
Passionate about .NET, Docker, Kubernetes and Software Architecture

<footer>

<iconoir-twitter /> [@trichling](https://twitter.com/trichling)
<iconoir-github /> [trichling](https://github.com/trichling)
<iconoir-mail /> [tobias.richling@apetito.de](mailto:tobias.richling@apetito.de)

</footer>

---
layout: image-right
image: /DockerHarbour.jpg
---
# Agenda

- Ein Blick in die dunklen Ecken der Softwareentwicklung

- Ein praktischer Leitfaden zur Sauberkeit und Hygiene im eigenen Container

    - Je weniger Geschirr man hat, desto weniger muss man spülen

    - Wer das alte Service von Oma rausschmeißt, muss es gar nicht mehr spülen

- Was wenn beim aufräumen was kaputt geht?

---
layout: section
---

# Was ist das Problem?
Ein Blick auf den Dachboden der Softwareentwicklung

---
src: /pages/problem.md
---

---
layout: section
---

# Was kann man tun?
Chiseled Images eilen zur Rettung

---
src: /pages/chisieldToTheRescue.md
---

---
layout: section
---

# Was kann schiefgehen?
Zu Risiken und Nebenwirkungen

---
src: /pages/chisieldWhatCanGoWrong.md
---
---
layout: section
---

# Wie wäre es mit aufräumen?
Nur ein gelöschtes Image ist ein sicheres Image
---
src: /pages/cleanupYourRegistry.md
---
---
layout: section
---
# Fazit

---

# Fazit

<v-clicks>

- Alte Images sind wie alte Socken: Sie stinken und sollten regelmäßig gewechselt werden.

- syft & grype sind gute Tools, um Schwachstellen in Images zu finden (auch in CI / CD Pipelines).

- Chiseled Images sind ein guter Weg, um die Sicherheit und Performance von Containern zu verbessern.

- Aufräumen alter Images ist zusätzlich erforderlich.

- Auch das permanente Überwachen der Container Registry / Kubernetes Cluster ist dringend zu empfehlen.

</v-clicks>

---
background: /SqueezeContainer.jpg
layout: cover
---

# Vielen Dank für die Aufmerksamkeit!

## Habt ihr noch Fragen?

<div absolute bottom-5 right-0 left-0 text-center fw300>

<iconoir-twitter /> [@trichling](https://twitter.com/trichling)   · 

<iconoir-github /> [trichling](https://github.com/trichling) ·  

<iconoir-mail /> [tobias.richling@apetito.de](mailto:tobias.richling@apetito.de)


</div>