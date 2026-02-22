```md
# Kubernetes Network Chaos Lab
### Network Chaos Engineering & Observability on Kubernetes

---

## 👤 Author
**Anas Sghaier**  
Master 2 – Technologies et Réseaux des Télécommunications (TRT)  
Université Gustave Eiffel  

---

## 🎯 Project Purpose

This project is a **Network & Cloud practical lab** focused on **network-level chaos engineering in Kubernetes**.

A microservices application is deployed on a local Kubernetes cluster, where **controlled network latency** is injected in order to:
- evaluate application performance degradation,
- verify SLA violations,
- and observe system recovery **without redeployment**.

All experiments are **automated, reproducible and observable**.

---

## 🧱 Architecture Overview

```

User (Browser)
|
Port-forward
|
Frontend (Nginx)
|
Backend API (Python)
|
Network Chaos (tc netem on API Pod)

```

- Chaos is injected **only at the network layer**
- Application code remains unchanged
- Kubernetes handles orchestration and recovery

---

## 🛠 Technologies Used

| Category | Tools |
|-------|------|
| OS | Kali Linux |
| Containers | Docker |
| Orchestration | Kubernetes (kind) |
| Networking | tc, netem |
| Backend | Python |
| Frontend | Nginx |
| Automation | Bash |
| Results | CSV |
| Versioning | Git & GitHub |

---

## 📁 Repository Structure

```

K8s-Network-Chaos-Lab/
│
├── app/        # Frontend & API source code
├── k8s/        # Kubernetes manifests
├── scripts/    # Automation & chaos scripts
├── results/    # CSV measurements
└── README.md

````

---

## 🚀 Experiment Workflow (Step-by-Step)

### Step 1 — Environment Cleanup (Recommended)

```bash
cd scripts
pkill -f "kubectl.*port-forward" 2>/dev/null || true
kind delete cluster --name netchaos 2>/dev/null || true
kind get clusters
````

Ensures a **clean and reproducible environment** before each experiment.

---

### Step 2 — Kubernetes Cluster Creation

```bash
bash 02-create-kind-cluster.sh
```

Creates a local Kubernetes cluster named **netchaos** using `kind`.

---

### Step 3 — Application Deployment

```bash
bash 03-deploy.sh
kubectl -n netchaos get pods
kubectl -n netchaos get svc
```

Deploys:

* Frontend (Nginx)
* Backend API (Python)

---

### Step 4 — Frontend Access

```bash
kubectl -n netchaos port-forward svc/frontend-svc 8080:80
```

Access in browser:

```
http://127.0.0.1:8080
```

---

## 📊 Network Chaos Experiments

### Baseline (No Chaos)

```bash
bash 10-measure.sh baseline
```

* Normal latency (~30 ms)
* SLA respected
* CSV generated

---

### Latency Injection (Chaos)

```bash
bash 06-chaos-latency.sh add
bash 10-measure.sh latency
```

Injected parameters:

* Latency: **250 ms ± 50 ms**
* Tool: `tc netem`
* Target: API pod network interface

Observed effects:

* Increased response time
* SLA violation
* Degraded user experience

---

### Recovery Phase

```bash
bash 06-chaos-latency.sh del
bash 10-measure.sh recovery
```

* No redeployment required
* Latency returns to normal
* System stability preserved

---

## 📈 Results Summary

| Phase    | Avg Latency | Status       |
| -------- | ----------- | ------------ |
| Baseline | ~30 ms      | Normal       |
| Chaos    | ~450–700 ms | SLA Violated |
| Recovery | ~30–40 ms   | Normal       |

All results are exported as **CSV files** for offline analysis.

---

## ✅ Key Learning Outcomes

* Network conditions can heavily impact application performance
* Kubernetes applications can recover **without redeployment**
* Chaos Engineering is effective for resilience validation
* Observability is essential for performance analysis

---

## 🧹 Cleanup

```bash
bash 99-cleanup.sh
```

Deletes the cluster and cleans the environment.

---

## 🧠 Conclusion

This project demonstrates how **network-level chaos in Kubernetes** directly affects application performance and user experience.

By combining **Docker, Kubernetes, Linux networking tools and chaos engineering**, this lab provides a realistic and reproducible framework for **Network & Cloud experimentation**.
