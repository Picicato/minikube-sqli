resource "kubernetes_namespace" "monitor" {
  metadata {
    name = var.namespace
  }
}

# Déployer kube-prometheus-stack via Helm
resource "helm_release" "kube_prometheus" {
  name       = "kube-prom-stack"
  namespace  = kubernetes_namespace.monitor.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "45.7.0" # exemple — tu peux ajuster ou omettre pour dernière compatible

  values = [
    file("${path.module}/prometheus_values.yaml")
  ]
}

# Déploiement de l'API webhook
resource "kubernetes_deployment" "alert_api" {
  metadata {
    name      = "alert-api"
    namespace = kubernetes_namespace.monitor.metadata[0].name
    labels = { app = "alert-api" }
  }

  spec {
    replicas = 1
    selector {
      match_labels = { app = "alert-api" }
    }
    template {
      metadata {
        labels = { app = "alert-api" }
      }
      spec {
        container {
          name  = "alert-api"
          image = "alert-api:latest" # on utilisera `minikube image load` (voir plus bas)
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "alert_api_svc" {
  metadata {
    name      = "alert-api-svc"
    namespace = kubernetes_namespace.monitor.metadata[0].name
  }

  spec {
    selector = kubernetes_deployment.alert_api.spec[0].template[0].metadata[0].labels
    port {
      port        = 80
      target_port = 5000
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}
