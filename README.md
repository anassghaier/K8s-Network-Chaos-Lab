Oui — et tu as déjà **une très bonne base**.
Ce que je te propose maintenant, c’est un **README “niveau GitHub pro / recruteur / jury”**, plus **attractif**, plus **orienté impact**, tout en restant **académiquement sérieux**.

👉 Tu peux **remplacer entièrement** ton README actuel par celui-ci.

---

```md
# 🚀 Kubernetes Network Chaos Lab  
### Network Chaos Engineering & Observability on Kubernetes

> **Latency injection, performance degradation analysis and recovery validation  
in a Kubernetes-based microservices architecture**

---

## 👤 Author
**Anas Sghaier**  
🎓 Master 2 – *Technologies et Réseaux des Télécommunications (TRT)*  
🏫 Université Gustave Eiffel  

---

## 🎯 Project Overview

This project is a **hands-on Network & Cloud engineering lab** focused on **Chaos Engineering at the network layer** in Kubernetes.

A complete **microservices application** is deployed on a local Kubernetes cluster, where **controlled network latency** is injected to study its **impact on application performance, SLA compliance, and system resilience**.

The application code remains **unchanged** throughout the experiments — only the **network behavior** is altered.

✔ Fully automated  
✔ Reproducible experiments  
✔ Observable performance impact  
✔ Clean recovery without redeployment  

---

## 🧠 Key Objectives

- Deploy a **containerized microservices application** on Kubernetes
- Build and manage Docker images
- Create a local Kubernetes cluster using **kind**
- Configure Kubernetes services and networking
- Inject **controlled network latency** using `tc netem`
- Observe application behavior **before, during and after chaos**
- Measure performance metrics and export results in **CSV format**
- Demonstrate **system recovery without redeployment**
- Apply **DevOps & Chaos Engineering** principles

---

## 🏗️ System Architecture

```

User (Web Browser)
|
v
Port-forward / NodePort
|
v
Frontend Service (Nginx)
|
v
Backend API Service (Python)
|
v
Network Chaos Injection
(tc netem on API Pod)

```

### Architecture Highlights
- **Frontend**: Nginx web interface  
- **Backend API**: Python service handling compute requests  
- **Chaos scope**: Network layer only (no application changes)  
- **Orchestration**: Kubernetes manages scheduling, services and recovery  

---

## 🛠️ Technologies & Tools

| Category | Technologies |
|-------|-------------|
| OS | Kali Linux |
| Containers | Docker |
| Orchestration | Kubernetes (kind) |
| Networking | tc, netem |
| Backend | Python |
| Frontend | Nginx |
| Automation | Bash scripting |
| Observability | Web dashboard |
| Data analysis | CSV exports |
| Version control | Git & GitHub |

---

## 📁 Project Structure

```

K8s-Network-Chaos-Lab/
│
├── app/                # Frontend & API source code
├── k8s/                # Kubernetes manifests
├── scripts/            # Automation & chaos scripts
│   ├── 02-create-kind-cluster.sh
│   ├── 03-deploy.sh
│   ├── 06-chaos-latency.sh
│   ├── 10-measure.sh
│   └── 99-cleanup.sh
│
├── results/            # Performance measurements (CSV)
│   ├── baseline_*.csv
│   ├── latency_*.csv
│   └── recovery_*.csv
│
└── README.md

````

---

## ♻️ Clean Start (Recommended)

To guarantee reproducibility, the environment is reset before each experiment:

```bash
cd scripts

pkill -f "kubectl.*port-forward" 2>/dev/null || true
kind delete cluster --name netchaos 2>/dev/null || true
kind get clusters
````

---

## 🚢 Cluster Creation

```bash
bash 02-create-kind-cluster.sh
```

This script:

* Creates a Kubernetes cluster named `netchaos`
* Configures networking and NodePort access
* Prepares the environment for deployment

---

## 📦 Application Deployment

```bash
bash 03-deploy.sh
```

This step:

* Builds Docker images (frontend & API)
* Loads images into the cluster
* Deploys Kubernetes manifests
* Creates services for frontend and backend

Verification:

```bash
kubectl -n netchaos get pods -o wide
kubectl -n netchaos get svc
```

---

## 🌐 Application Access

The frontend listens on **port 80** inside the container and is exposed locally:

```bash
kubectl -n netchaos port-forward svc/frontend-svc 8080:80
```

Access via browser:

```
http://127.0.0.1:8080
```

---

## 📊 Performance Measurement Workflow

### 1️⃣ Baseline (No Chaos)

```bash
bash 10-measure.sh baseline
```

* Normal network conditions
* Low latency
* SLA respected

---

### 2️⃣ Network Chaos Injection

```bash
bash 06-chaos-latency.sh add
```

Injected parameters:

* **Latency**: 250 ms ± 50 ms
* **Tool**: `tc netem`
* **Target**: API pod network interface

---

### 3️⃣ Measurement During Chaos

```bash
bash 10-measure.sh latency
```

Observed effects:

* Increased response time
* SLA violation
* Degraded user experience

---

### 4️⃣ Recovery Phase

```bash
bash 06-chaos-latency.sh del
bash 10-measure.sh recovery
```

✔ No redeployment required
✔ Network returns to normal state
✔ System stability preserved

---

## 📈 Results Summary

| Phase    | Average Latency | Status       |
| -------- | --------------- | ------------ |
| Baseline | ~30 ms          | Normal       |
| Chaos    | ~450–700 ms     | SLA violated |
| Recovery | ~30–40 ms       | Normal       |

All results are exported as **CSV files** for offline analysis.

---

## ✅ Compliance with Course Requirements

| Requirement                  | Status |
| ---------------------------- | ------ |
| Practical project            | ✔      |
| Docker usage                 | ✔      |
| Kubernetes deployment        | ✔      |
| Network experimentation      | ✔      |
| Chaos engineering            | ✔      |
| Automation & reproducibility | ✔      |
| GitHub versioning            | ✔      |

---

## 🧩 Conclusion

This project demonstrates how **network-level impairments in Kubernetes** can severely impact application performance, even when the application itself remains unchanged.

By combining **Docker, Kubernetes, Linux networking tools and Chaos Engineering**, this lab provides a realistic and reproducible environment to **study resilience, observability and performance degradation** in modern cloud-native systems.

---

 *This project was developed for academic and educational purposes and can serve as a foundation for further experiments such as packet loss, jitter or multi-service chaos scenarios.*
