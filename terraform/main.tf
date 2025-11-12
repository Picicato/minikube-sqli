terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.18.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Create a namespace for the application
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# Deploy a Helm chart for Prometheus in the monitoring namespace
resource "helm_release" "prometheus_stack" {
  name       = "monitoring-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "46.0.0"

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_password
  }
}