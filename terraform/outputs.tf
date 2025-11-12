output "grafana_admin_password" {
  value = var.grafana_password
}

output "grafana_portforward_command" {
  value = "minikube kubectl -- port-forward -n monitoring svc/monitoring-stack-grafana 3000:80 &"
}
