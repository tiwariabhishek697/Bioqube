helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Deploy Prometheus
helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace

# Deploy Grafana
helm install grafana grafana/grafana --namespace monitoring