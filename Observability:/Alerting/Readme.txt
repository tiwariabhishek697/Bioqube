Prerequisites

Prometheus is deployed and running in your Kubernetes clusters.
Blackbox Exporter is deployed to monitor HTTP endpoints.
The /health endpoint of the FastAPI app is accessible.

Deploy Blackbox Exporter
The Blackbox Exporter is a Prometheus exporter for probing endpoints over HTTP, HTTPS, DNS, TCP, and ICMP.

Deploy Blackbox Exporter Using Helm

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Deploy Blackbox Exporter
helm install blackbox-exporter prometheus-community/prometheus-blackbox-exporter --namespace monitoring --create-namespace
Verify Deployment
Ensure the Blackbox Exporter service is running:
kubectl get svc -n monitoring

Configure Prometheus to Scrape the /health Endpoint
Update the Prometheus configuration to use the Blackbox Exporter for probing the /health endpoint.