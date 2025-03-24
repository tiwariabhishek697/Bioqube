Access Grafana:

Retrieve the Grafana admin password:

kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

Access Grafana via the service's external IP or port-forwarding:

kubectl port-forward --namespace monitoring svc/grafana 3000:80
Login to Grafana at http://ip:3000 using the username admin and the retrieved password.
Add Prometheus as a Data Source:

In Grafana, go to Configuration > Data Sources > Add Data Source.
Select Prometheus and provide the Prometheus service URL (e.g., http://<prometheus-service-ip>:9090).

Create a Custom Dashboard:
Go to Create > Dashboard > Add New Panel.

Add queries to visualize metrics like:
Request latency: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
Error rates: rate(http_requests_total{status=~"5.."}[5m])
Request count: rate(http_requests_total[5m])
Save the dashboard and name it (e.g., "FastAPI App Metrics")
