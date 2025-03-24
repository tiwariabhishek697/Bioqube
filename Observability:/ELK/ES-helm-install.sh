helm repo add elastic https://helm.elastic.co
helm repo update

# Deploy Elasticsearch
helm install elasticsearch elastic/elasticsearch --namespace logging --create-namespace