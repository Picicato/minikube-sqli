resource "kubernetes_namespace" "lab" {
  metadata {
    name = var.namespace
  }
}

output "namespace" {
  value = kubernetes_namespace.lab.metadata[0].name
}