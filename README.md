
# Kubernetes Network Chaos Lab
### Chaos Engineering réseau & Observabilité sur Kubernetes

---

## 👤 Auteur
**Anas Sghaier**  
Master 2 – Technologies et Réseaux des Télécommunications (TRT)  
Université Gustave Eiffel  

---

## 🎯 Présentation du projet

Ce projet a été développé dans le cadre du TP **Network & Cloud** du Master 2 TRT.

L'objectif est de mettre en place un **laboratoire d'expérimentation de Chaos Engineering au niveau réseau dans Kubernetes** afin d'observer l’impact des perturbations réseau sur une application microservices.

Une application composée de :

- un **frontend Nginx**
- une **API backend en Python**

est déployée sur un **cluster Kubernetes local (kind)**.

Une **latence réseau contrôlée** est ensuite injectée à l'aide de l’outil Linux **tc netem** afin d'évaluer :

- la dégradation des performances applicatives
- les violations de SLA
- la capacité de récupération du système **sans redéploiement**

Toutes les expérimentations sont :

- **automatisées**
- **reproductibles**
- **observables via un dashboard**

---

## 🧱 Architecture du système

User (Browser)  
│  
Port-forward (kubectl)  
│  
Frontend (Nginx)  
│  
Backend API (Python)  
│  
Network Chaos (tc netem sur le Pod API)

Principes clés :

- Le chaos est injecté **uniquement au niveau réseau**
- Le code applicatif **reste inchangé**
- Kubernetes assure l’orchestration et la stabilité du système

---

## 🛠 Technologies utilisées

| Catégorie | Outils |
|--------|------|
| OS | Kali Linux |
| Conteneurs | Docker |
| Orchestration | Kubernetes (kind) |
| Réseau | tc, netem |
| Backend | Python |
| Frontend | Nginx |
| Automatisation | Bash |
| Observabilité | Dashboard Web |
| Résultats | CSV |
| Versioning | Git & GitHub |

---

## 📁 Structure du dépôt

K8s-Network-Chaos-Lab/
├── app/        # Code source frontend et backend
├── k8s/        # Manifests Kubernetes
├── scripts/    # Scripts d'automatisation et de chaos
├── results/    # Résultats des expériences (CSV)
└── README.md

---

# 🚀 Déroulement des expériences

## 1️⃣ Nettoyage de l’environnement

Avant chaque expérimentation, l’environnement est remis à zéro.

```bash
cd ~/Pictures/K8s-Network-Chaos-Lab_FINAL/scripts

pkill -f "kubectl.*port-forward" 2>/dev/null || true
kind delete cluster --name netchaos 2>/dev/null || true
kind get clusters
```

Cela permet de garantir :

- un environnement propre
- aucune session port-forward active
- aucun cluster résiduel

---

## 2️⃣ Création du cluster Kubernetes

```bash
bash 02-create-kind-cluster.sh
```

Création d’un cluster Kubernetes local nommé :

```
netchaos
```

---

## 3️⃣ Déploiement de l'application

```bash
bash 03-deploy.sh
```

Puis vérification :

```bash
kubectl -n netchaos get pods -o wide
kubectl -n netchaos get svc
```

Cette étape permet de vérifier :

- que les pods sont **Running**
- que les services Kubernetes sont correctement exposés

---

## 4️⃣ Test du port réel du frontend

Avant d'exposer le service, on vérifie sur quel port **Nginx écoute réellement dans le conteneur**.

```bash
kubectl -n netchaos exec deploy/frontend -- sh -c 'wget -qO- http://127.0.0.1:80/ >/dev/null && echo "FRONT OK sur 80" || echo "PAS sur 80"'
```

```bash
kubectl -n netchaos exec deploy/frontend -- sh -c 'wget -qO- http://127.0.0.1:8080/ >/dev/null && echo "FRONT OK sur 8080" || echo "PAS sur 8080"'
```

Cette étape évite un décalage entre :

- le port du conteneur
- le port du service Kubernetes

---

## 5️⃣ Correction dynamique du Service Kubernetes

Si le frontend utilise **le port 80** :

```bash
kubectl -n netchaos patch svc frontend-svc --type='json' -p='[
 {"op":"replace","path":"/spec/ports/0/port","value":80},
 {"op":"replace","path":"/spec/ports/0/targetPort","value":80}
]'
```

Si le frontend utilise **le port 8080** :

```bash
kubectl -n netchaos patch svc frontend-svc --type='json' -p='[
 {"op":"replace","path":"/spec/ports/0/port","value":8080},
 {"op":"replace","path":"/spec/ports/0/targetPort","value":8080}
]'
```

Cela illustre la **reconfiguration dynamique du réseau Kubernetes sans redéployer les pods**.

---

## 6️⃣ Accès au frontend

```bash
kubectl -n netchaos port-forward svc/frontend-svc 8080:80
```

ou

```bash
kubectl -n netchaos port-forward svc/frontend-svc 8080:8080
```

Puis ouvrir :

```
http://127.0.0.1:8080
```

---

# 📊 Expériences de Chaos Engineering

## Baseline — Conditions réseau normales

```bash
bash 10-measure.sh baseline
```

Résultats typiques :

- Latence ≈ **30 ms**
- SLA respecté
- CSV généré

![Baseline dashboard](docs/dashboard-baseline.png)

---

## Chaos — Injection de latence réseau

```bash
bash 06-chaos-latency.sh add
```

Puis mesure :

```bash
bash 10-measure.sh latency
```

Paramètres injectés :

- Latence : **250 ms ± 50 ms**
- Outil : `tc netem`
- Cible : **pod API**

Effets observés :

- augmentation du temps de réponse
- violation du SLA
- dégradation de l’expérience utilisateur

![Chaos dashboard](docs/dashboard-chaos.png)

---

## Recovery — Suppression du chaos

```bash
bash 06-chaos-latency.sh del
```

Puis mesure de récupération :

```bash
bash 10-measure.sh recovery
```

Le système revient à un état nominal **sans redéploiement**.

![Recovery dashboard](docs/dashboard-recovery.png)

---

## 📈 Résumé des résultats

| Phase | Latence moyenne | Statut |
|------|----------------|--------|
| Baseline | ~30 ms | Normal |
| Chaos | ~450–700 ms | SLA violé |
| Recovery | ~30–40 ms | Normal |

Toutes les mesures sont exportées sous forme de **fichiers CSV** pour analyse hors ligne.

![CSV results](docs/csv-results.png)

---

## 🧹 Nettoyage

```bash
bash 99-cleanup.sh
```

Supprime le cluster et nettoie l’environnement.

---

## 🧠 Conclusion

Ce laboratoire démontre comment **les perturbations réseau dans Kubernetes impactent directement les performances applicatives et l’expérience utilisateur**.

En combinant :

- Docker
- Kubernetes
- les outils réseau Linux (`tc netem`)
- le Chaos Engineering

ce projet constitue un **environnement réaliste d’expérimentation pour l’analyse de résilience des architectures microservices dans le Cloud**.
