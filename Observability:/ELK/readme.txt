Deploy Elasticsearch:
Used Helm to deploy Elasticsearch in a dedicated Kubernetes cluster 
Ensure sufficient resources and persistent storage for Elasticsearch.

Configuration:
Used a Ingress to expose Elasticsearch to both AWS and GCP clusters.


Fluentd for Log Collection
Why Fluentd?
Fluentd is lightweight and efficient for collecting logs from Kubernetes pods.
It can forward logs to Logstash for processing.
Deployment Steps:
Deploy Fluentd as a DaemonSet:
Fluentd runs on every node in the Kubernetes cluster to collect logs from /var/log/containers.

Configure Fluentd to Forward Logs to Logstash:
Update Fluentd configuration to forward logs to Logstas


Logstash for Log Processing
Why Logstash?
Logstash processes, filters, and enriches logs before sending them to Elasticsearch.
Used Helm to deploy Logstash in the same cluster as Elasticsearch.

helm install logstash elastic/logstash --namespace logging