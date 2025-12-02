resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  namespace  = var.namespace
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "45.7.0"

  values = [
    file("${path.module}/values.yaml")
  ]
}

output "kube_prometheus_ready" {
  value = helm_release.kube_prometheus_stack.status
}

