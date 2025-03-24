Deploy the Configuration
Apply the updated Prometheus configuration:

kubectl apply -f prometheus-config.yaml
Apply the alert rules:

kubectl apply -f alert.rules.yml
Apply the Alertmanager configuration:

kubectl apply -f alertmanager-config.yaml