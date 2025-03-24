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




Push the Image to AWS ECR and GCP Artifact Registry:
AWS ECR:

bash
Copy Code
# Login to AWS ECR
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com

# Tag the image
docker tag fastapi-app:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/fastapi-app:latest

# Push the image
docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/fastapi-app:latest
GCP Artifact Registry:

bash
Copy Code
# Configure Docker authentication
gcloud auth configure-docker

# Tag the image
docker tag fastapi-app:latest <gcp_region>-docker.pkg.dev/<project_id>/fastapi-app/fastapi-app:latest

# Push the image
docker push <gcp_region>-docker.pkg.dev/<project_id>/fastapi-app/fastapi-app:latest
Deploy the Application to Kubernetes Clusters:
bash
Copy Code
helm install fastapi-app ./Containerization\ and\ Deployment/Helm/fastapi-app/
Configure Horizontal Pod Autoscaling (HPA):
Ensure HPA is enabled in the Helm chart or apply manually:

bash
Copy Code
kubectl autoscale deployment fastapi-app --cpu-percent=50 --min=3 --max=10
