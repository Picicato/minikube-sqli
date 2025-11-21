resource "helm_release" "kube_prometheus" {
  name       = "kube-prom-stack"
  namespace  = var.namespace
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "45.7.0"

  values = [
    file("${path.module}/values.yaml")
  ]
}
