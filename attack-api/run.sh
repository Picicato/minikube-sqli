#!/bin/bash

set -e

# Install Docker
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Minikube dependencies
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

minikube start

# Build and deploy the attack-api application
minikube image build -t attack-api:lastest .
minikube image ls | grep attack-api || docker images | grep attack-api

kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

kubectl -n observability-demo get pods/svc

# API Testing
kubectl port-forward -n observability-demo svc:attack-api 8080:80 &

curl -s http://localhost:8080/
curl -s -X POST http://localhost:8080/simulate-attack
curl -s http://localhost:8080/metrics

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install kube-prometheus-stack using Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install kp-stack prometheus-community/kube-prometheus-stack --namespace observability-demo --create-namespace --wait

kubectl -n observability-demo get pods,svc

# Port-forward to access Prometheus and Grafana
kubectl port-forward -n observability-demo svc/kp-stack-kube-prometheus-s-prometheus 9090:9090 &
kubectl port-forward -n observability-demo svc/kp-stack-grafana 3000:80 &
kubectl port-forward -n observability-demo get svc/kp-stack-kube-prometheus-s-alertmanager 9093:8080 &

kubectl get secret -n observability-demo kp-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

helm upgrade kp-stack prometheus-community/kube-prometheus-stack --namespace observability-demo --set prometheus.prometheusSpec.retention="1h" --set prometheus.prometheusSpec.resources.requests.memory="512Mi" --set prometheus.prometheusSpec.resources.limits.memory="1Gi"

