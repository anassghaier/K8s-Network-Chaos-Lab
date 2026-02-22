
---

```md
# K8s Network Chaos Lab — Network & Cloud Practical Project

## Author
**Anas Sghaier**  
Master 2 – Technologies et Réseaux des Télécommunications (TRT)  
Université Gustave Eiffel  

---

## 1. Project Context

This project was developed as part of the **Network & Cloud** practical work (Session 2 – Project Presentation).  
The objective is to design, deploy, configure and experiment with a **Kubernetes-based microservices system**, while studying the **impact of network impairments** on application performance.

The project follows **DevOps** and **Chaos Engineering** principles and is fully automated using shell scripts.  
All experiments are reproducible and the source code is versioned on GitHub.

---

## 2. Project Objectives

The main goals of this project are:

- Deploy a microservices application on Kubernetes
- Use Docker for containerization
- Create a local Kubernetes cluster using **kind**
- Configure Kubernetes networking and services
- Inject controlled network latency using **tc netem**
- Observe application behavior before, during and after chaos
- Measure performance metrics and export results in CSV format
- Demonstrate system recovery without redeployment

---

## 3. System Architecture

```

User (Web Browser)
|
v
NodePort / Port-forward
|
v
Frontend Service (Nginx)
|
v
Backend API Service (Python)
|
v
Network Chaos (tc netem on API Pod)

```

- The **frontend** exposes a web dashboard
- The **backend API** performs compute requests
- Chaos is injected **only at the network layer**
- Kubernetes handles orchestration and service discovery

---

## 4. Tools & Technologies

| Category | Tools |
|--------|------|
| OS | Kali Linux |
| Containerization | Docker |
| Orchestration | Kubernetes (kind) |
| Networking | tc, netem |
| Backend | Python |
| Frontend | Nginx |
| Automation | Bash |
| Observability | Web dashboard |
| Data export | CSV |
| Version control | Git / GitHub |

---

## 5. Project Structure

```

K8s-Network-Chaos-Lab_FINAL/
│
├── scripts/
│   ├── 02-create-kind-cluster.sh
│   ├── 03-deploy.sh
│   ├── 06-chaos-latency.sh
│   ├── 10-measure.sh
│   └── 99-cleanup.sh
│
├── manifests/
│   ├── api.yaml
│   └── frontend.yaml
│
├── results/
│   ├── baseline_*.csv
│   ├── latency_*.csv
│   └── recovery_*.csv
│
└── README.md

````

---

## 6. Clean Start Procedure (Recommended)

Before each experiment, the environment is fully reset to avoid conflicts.

```bash
cd ~/Pictures/K8s-Network-Chaos-Lab_FINAL/scripts

# Stop any existing port-forward
pkill -f "kubectl.*port-forward" 2>/dev/null || true

# Delete existing cluster if present
kind delete cluster --name netchaos 2>/dev/null || true

# Verify no cluster remains
kind get clusters
````

This guarantees a **clean and reproducible environment**.

---

## 7. Cluster Creation

```bash
bash 02-create-kind-cluster.sh
```

This script:

* Creates a Kubernetes cluster named `netchaos`
* Configures networking and NodePort access
* Prepares the environment for application deployment

---

## 8. Application Deployment

```bash
bash 03-deploy.sh
```

This step:

* Builds Docker images (frontend & API)
* Loads images into the kind cluster
* Deploys Kubernetes manifests
* Creates services for frontend and API

Verification:

```bash
kubectl -n netchaos get pods -o wide
kubectl -n netchaos get svc
```

---

## 9. Frontend Service Port Validation

The frontend container is tested internally to determine the listening port.

```bash
kubectl -n netchaos exec deploy/frontend -- sh -c \
'wget -qO- http://127.0.0.1:80/ >/dev/null && echo "FRONT OK sur 80" || echo "PAS sur 80"'

kubectl -n netchaos exec deploy/frontend -- sh -c \
'wget -qO- http://127.0.0.1:8080/ >/dev/null && echo "FRONT OK sur 8080" || echo "PAS sur 8080"'
```

In this project, the frontend was confirmed to be listening on **port 80**.

The service is therefore patched accordingly:

```bash
kubectl -n netchaos patch svc frontend-svc --type='json' -p='[
  {"op":"replace","path":"/spec/ports/0/port","value":80},
  {"op":"replace","path":"/spec/ports/0/targetPort","value":80}
]'
```

---

## 10. Application Access

The frontend service is exposed locally using port-forwarding:

```bash
kubectl -n netchaos port-forward svc/frontend-svc 8080:80
```

Access via browser:

```
http://127.0.0.1:8080
```

---

## 11. Performance Measurement Workflow

### 11.1 Baseline Measurement (No Chaos)

```bash
bash 10-measure.sh baseline
```

* Normal network conditions
* Low latency
* SLA respected
* CSV file generated in `results/`

---

### 11.2 Network Latency Injection

```bash
bash 06-chaos-latency.sh add
```

Injected parameters:

* Latency: **250 ms ± 50 ms**
* Tool: `tc netem`
* Target: API pod network interface

---

### 11.3 Measurement During Chaos

```bash
bash 10-measure.sh latency
```

Observed effects:

* Increased response time
* SLA violation
* Degraded user experience
* CSV file generated

---

### 11.4 Chaos Removal (Recovery)

```bash
bash 06-chaos-latency.sh del
```

No redeployment is required.
The network returns to its normal state.

---

### 11.5 Post-Chaos Measurement

```bash
bash 10-measure.sh recovery
```

Confirms:

* Latency returns to baseline
* System stability
* Successful recovery

---

## 12. Results Summary

| Phase    | Average Latency | Status       |
| -------- | --------------- | ------------ |
| Baseline | ~30 ms          | Normal       |
| Chaos    | ~450–700 ms     | SLA Violated |
| Recovery | ~30–40 ms       | Normal       |

All measurements are exported as CSV files for offline analysis.

---

## 13. Compliance with Course Requirements

| Requirement                       | Status |
| --------------------------------- | ------ |
| Practical project                 | ✔      |
| System deployment & configuration | ✔      |
| Docker usage                      | ✔      |
| Kubernetes usage                  | ✔      |
| Network experimentation           | ✔      |
| Chaos engineering                 | ✔      |
| GitHub source code                | ✔      |

---

## 14. Conclusion

This project demonstrates how **network-level impairments in Kubernetes** can significantly impact application performance, even when the application itself remains unchanged.

By combining **Docker, Kubernetes, Linux networking tools, and chaos engineering**, this work provides a realistic and reproducible environment for experimenting with Network & Cloud systems and validating their resilience.

---

