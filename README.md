# Multi-Cloud DevOps Assignment

## Objective

The goal of this assignment is to deploy a Python FastAPI application across multiple cloud providers (AWS and GCP) with a focus on:

- High availability
- Fault tolerance
- Security
- Observability
- Automation

---

## Architecture Overview

### Multi-Cloud Network Architecture

The architecture spans across AWS and GCP, with the following key components:

#### AWS Cloud:
- **VPC**: A Virtual Private Cloud with public and private subnets.
- **NAT Gateway**: Allows private subnet resources to access the internet securely.
- **EKS (Elastic Kubernetes Service)**: A managed Kubernetes cluster for deploying the FastAPI application.
- **Load Balancer**: Distributes traffic to the application pods running in the EKS cluster.

#### GCP Cloud:
- **VPC**: A Virtual Private Cloud with public and private subnets.
- **Cloud NAT**: Provides internet access for private subnet resources.
- **GKE (Google Kubernetes Engine)**: A managed Kubernetes cluster for deploying the FastAPI application.
- **HTTP Load Balancer**: Distributes traffic to the application pods running in the GKE cluster.

### Traffic Management:
- **AWS Global Accelerator**: Provides a single static IP for the application and routes traffic to the nearest healthy endpoint (AWS or GCP).
- **Route 53**: Manages DNS records and provides weighted routing between AWS and GCP.

---

## Key Components

### 1. Multi-Cloud Infrastructure as Code (IaC)
- **Tool**: Terraform
- **Purpose**: Automate the provisioning of infrastructure across AWS and GCP.
- **Features**:
  - VPCs with public and private subnets.
  - Managed Kubernetes clusters (EKS on AWS, GKE on GCP).
  - Networking configurations (e.g., NAT Gateways, firewalls).
  - Geographic redundancy by deploying clusters in different regions.

### 2. Containerization and Deployment
- **Tool**: Docker
- **Purpose**: Package the FastAPI application into a lightweight, portable container.
- **Features**:
  - Optimized Dockerfile using `python:3.9-slim`.
  - Non-root user for enhanced security.
  - Exposes the application on port 80.

- **Deployment**:
  - **Tool**: Helm (or Kubernetes manifests).
  - **Features**:
    - Horizontal Pod Autoscaling (HPA) based on CPU/memory usage.
    - Minimum of 3 replicas per cluster for high availability.

### 3. CI/CD Pipeline
- **Tool**: GitHub Actions or GitLab CI
- **Purpose**: Automate the build, test, and deployment process.
- **Pipeline Features**:
  - Build and tag the Docker image with a version (e.g., Git commit SHA).
  - Push the image to a secure container registry (AWS ECR, GCP Artifact Registry).
  - Run a vulnerability scan using Trivy.
  - Deploy to Kubernetes clusters using a canary or blue-green strategy.
  - Rollback mechanism if the `/health` endpoint fails.

### 4. Security
- **Cluster Hardening**:
  - Enable RBAC with least-privilege roles for the application.
  - Use Network Policies to restrict pod-to-pod communication.

- **TLS Encryption**:
  - Use Cert-Manager to issue TLS certificates for the application.

- **Secrets Management**:
  - Store sensitive data (e.g., API keys) in AWS Secrets Manager or HashiCorp Vault.

### 5. Fault Tolerance and Traffic Management
- **Multi-Cloud Load Balancer**:
  - AWS Global Accelerator: Routes traffic to the nearest healthy endpoint.
  - Route 53: Provides DNS-based traffic management with health checks.

- **Failure Simulation**:
  - Simulate a cluster failure and ensure traffic is rerouted to the surviving cluster with minimal downtime.

### 6. Observability
- **Monitoring**:
  - Prometheus: Scrapes metrics from the FastAPI application and Kubernetes clusters.
  - Grafana: Visualizes metrics on custom dashboards.

- **Logging**:
  - Loki or ELK Stack: Aggregates logs from both clusters.

- **Alerting**:
  - Alertmanager: Sends alerts when the `/health` endpoint returns unhealthy.

---

## Setup and Installation

### 1. Infrastructure Setup
Use Terraform to provision the infrastructure:

```bash
# Navigate to the Terraform directory
cd Multi-cloud-terraform

# Initialize Terraform
terraform init

# Plan the infrastructure
terraform plan

# Apply the infrastructure
terraform apply




# Application Deployment

## 2. Application Deployment

### Build and Deploy the FastAPI Application

#### Build the Docker Image:

```bash
docker build -t fastapi-app:latest .



### Push Images to AWS ECR

To push your Docker images to Amazon Elastic Container Registry (ECR), follow these commands:

#### 1. Login to AWS ECR
```bash
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com

# Tag the image
docker tag fastapi-app:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/fastapi-app:latest

# Push the image
docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/fastapi-app:latest



###GCP Artifact Registry:


# Configure Docker authentication
gcloud auth configure-docker

# Tag the image
docker tag fastapi-app:latest <gcp_region>-docker.pkg.dev/<project_id>/fastapi-app/fastapi-app:latest

# Push the image
docker push <gcp_region>-docker.pkg.dev/<project_id>/fastapi-app/fastapi-app:latest
Deploy the Application to Kubernetes Clusters:

helm install fastapi-app ./Containerization\ and\ Deployment/Helm/fastapi-app/
Configure Horizontal Pod Autoscaling (HPA):
Ensure HPA is enabled in the Helm chart or apply manually:
kubectl autoscale deployment fastapi-app --cpu-percent=50 --min=3 --max=10

Testing and Validation
1. Fault Tolerance Testing Script

#!/bin/bash

# Simulate cluster failure
kubectl config use-context cluster1
kubectl drain node --ignore-daemonsets

# Verify traffic routing
for i in {1..10}; do
  curl -v https://your-app-endpoint/
  sleep 2
done

# Restore cluster
kubectl uncordon node
2. Security Testing Commands

# Test RBAC
kubectl auth can-i create pods --as=system:serviceaccount:default:app-sa

# Test Network Policies
kubectl run test-pod --image=busybox -- wget -O- http://fastapi-app-svc

# Test TLS
curl -v https://your-app-endpoint/
3. Observability Testing

# Verify Prometheus metrics
curl http://prometheus:9090/api/v1/query?query=up

# Test alerting
kubectl patch deployment fastapi-app -p '{"spec": {"template": {"spec": {"containers": [{"name": "fastapi-app", "env": [{"name": "HEALTH_CHECK_FAIL", "value": "true"}]}]}}}}'


### 4. Promote to Production

**Stage**: `promote-to-production`

This stage promotes the application to production in both AWS and GCP clusters. It performs the following steps:

1. Updates the kubeconfig for AWS EKS and deploys the application to production with three replicas (`replicaCount=3`).
2. Removes the canary deployment from AWS.
3. Updates the kubeconfig for GCP GKE and deploys the application to production with three replicas (`replicaCount=3`).
4. Removes the canary deployment from GCP.

**Script**:
```bash
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_AWS
helm upgrade --install fastapi-app ./helm/fastapi-app -n default \
    --set image.repository=<aws-account-id>.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME \
    --set image.tag=$CI_COMMIT_SHA \
    --set replicaCount=3
helm uninstall fastapi-app-canary -n default

gcloud container clusters get-credentials $CLUSTER_GCP --region $GCP_REGION --project $GCP_PROJECT
helm upgrade --install fastapi-app ./helm/fastapi-app -n default \
    --set image.repository=$GCP_REGION-docker.pkg.dev/$GCP_PROJECT/$IMAGE_NAME \
    --set image.tag=$CI_COMMIT_SHA \
    --set replicaCount=3
helm uninstall fastapi-app-canary -n default




### 5. Health Check Production

**Stage**: `health-check-production`

This stage validates the health of the production deployment by performing the following steps:

1. Retrieves the IP addresses of the production services in both AWS and GCP.
2. Sends HTTP requests to the `/health` endpoint of the production services.
3. Checks if the HTTP status code is `200`.
4. If the health check fails, the production deployment is rolled back using Helm.

**Script**:
```bash
PROD_AWS_IP=$(kubectl get svc fastapi-app -n default -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
PROD_GCP_IP=$(kubectl get svc fastapi-app -n default -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
STATUS_AWS=$(curl -s -o /dev/null -w "%{http_code}" "http://$PROD_AWS_IP/health")
STATUS_GCP=$(curl -s -o /dev/null -w "%{http_code}" "http://$PROD_GCP_IP/health")
if [ "$STATUS_AWS" -ne 200 ] || [ "$STATUS_GCP" -ne 200 ]; then
    echo "Production health check failed. Rolling back..."
    helm rollback fastapi-app 1 -n default
    exit 1
fi

