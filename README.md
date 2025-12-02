# 📌 SQL Injection Detection Pipeline on Kubernetes (Minikube)
## 🚀 Features
✅ Vulnerable Web Application
* Written in Python/Flask
* Exposes a SQL-injection-vulnerable /login endpoint
* Forwards user-submitted payloads directly to the SQLi Detector service

✅ PostgreSQL Database
* Auto-initialized with a users table via ConfigMap
* Used by the vulnerable application to demonstrate SQL injection behavior

✅ SQL Injection Detector Service
* Receives HTTP logs from the vulnerable app
* Matches payloads against SQLi patterns
* Exposes Prometheus metrics: sql_injection_attempts_total

✅ Monitoring Stack (kube-prometheus-stack)
* Prometheus scrapes sqli-detector metrics
* Alertmanager triggers alerts when an SQLi attempt is detected
* Grafana dashboards visualize the metrics

✅ Fully modular Terraform architecture
* namespace module
* postgres module
* app module
* sqli_detector module
* monitoring module

Each module is independently deployable and reusable.

## 🏗 Architecture
~~~bash
                 ┌─────────────────────────┐
                 │ Vulnerable Web App      │
                 │ /login (SQLi vulnerable)│  
                 │ sends payload →         │
                 └─────────────┬───────────┘
                               │
                               ▼
                   ┌───────────────────────┐
                   │ SQLi Detector Service │
                   │ /log endpoint         │
                   │ Detects SQLi patterns │
                   │ Exposes /metrics      │
                   └───────────┬───────────┘
                               │ Prometheus scrape
                               ▼
                   ┌───────────────────────┐
                   │       Prometheus      │
                   │     ServiceMonitor    │
                   └───────────┬───────────┘
                               │ alert rule
                               ▼
                   ┌──────────────────────┐
                   │     Alertmanager     │
                   │     Routes alerts    │
                   └───────────┬──────────┘
                               │
                               ▼
                   ┌───────────────────────┐
                   │       Grafana         │
                   │ Dashboards & Alerts   │
                   └───────────────────────┘
~~~
## 🔧 Prerequisites
* Minikube
* Terraform 1.3+
* Docker
* kubectl
* Helm

Start the project:
~~~bash
./start.sh
~~~

## 🧹 Clean Up
~~~bash
terraform destroy -auto-approve
minikube delete
~~~
