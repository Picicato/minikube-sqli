resource "kubernetes_manifest" "sqli_detector_servicemonitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "sqli-detector-sm"
      namespace = var.namespace
      labels = {
        release = "kube-prometheus-stack"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "sqli-detector"
        }
      }
      endpoints = [{
        port     = "8000"
        path     = "/metrics"
        interval = "10s"
      }]
    }
  }
}
