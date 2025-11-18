minikube kubectl -- -n monitoring port-forward svc/alert-api-svc 8080:80 &
minikube kubectl -- -n monitoring port-forward svc/kube-prom-stack-kube-prome-prometheus 9090:9090 &
minikube kubectl -- -n monitoring port-forward svc/kube-prom-stack-grafana 3000:80 &
minikube kubectl -- -n monitoring port-forward svc/kube-prom-stack-kube-prome-alertmanager 9093:9093 &
