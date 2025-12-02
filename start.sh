#!/bin/bash
set -e

minikube start --container-runtime=docker --driver=docker

# Build dans ton Docker local
docker build -t vuln-app:latest ./vuln-web
docker build -t sqli-detector:latest ./sqli-detector

cd terraform

terraform apply -target=module.namespace \
               -target=module.postgres \
               -target=module.app \
               -target=module.sqli_detector \
               -target=module.monitoring \
               --auto-approve

terraform apply -target=module.monitoring_addons --auto-approve

minikube kubectl -- -n sqli-lab port-forward svc/vuln-app 5000:80 &
minikube kubectl -- -n sqli-lab port-forward svc/kube-prometheus-stack-prometheus 9090:9090 &