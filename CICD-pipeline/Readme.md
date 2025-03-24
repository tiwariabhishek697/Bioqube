# CI/CD Pipeline Explanation

This pipeline is designed to deploy a FastAPI application across AWS and GCP Kubernetes clusters using a canary deployment strategy. It includes multiple stages to ensure the application is built, scanned, deployed, and validated before being promoted to production.

## Stages Overview

1. **Build**: Build the Docker image for the application.
2. **Scan**: Perform security scans on the Docker image.
3. **Deploy Canary**: Deploy the application as a canary release to both AWS and GCP clusters.
4. **Health Check Canary**: Validate the health of the canary deployment.
5. **Wait for Canary**: Observe the canary deployment for a specified period.
6. **Promote to Production**: Deploy the application to production if the canary deployment is successful.
7. **Health Check Production**: Validate the health of the production deployment.

---

## Variables

The pipeline uses the following variables:

- `AWS_REGION`: The AWS region where the EKS cluster is located (e.g., `us-east-1`).
- `GCP_PROJECT`: The GCP project ID.
- `GCP_REGION`: The GCP region where the GKE cluster is located (e.g., `us-central1`).
- `IMAGE_NAME`: The name of the Docker image to be deployed.
- `CLUSTER_AWS`: The name of the AWS EKS cluster.
- `CLUSTER_GCP`: The name of the GCP GKE cluster.
- `GCP_SERVICE_ACCOUNT_KEY`: The GCP service account key for authentication.

---

## Pipeline Stages

### 1. Deploy Canary

**Stage**: `deploy-canary`

- Deploys the application as a canary release to both AWS and GCP Kubernetes clusters.
- Uses Helm to install or upgrade the application with a single replica (`replicaCount=1`).
- Commands:
  - Updates the kubeconfig for AWS EKS and deploys the canary release.
  - Updates the kubeconfig for GCP GKE and deploys the canary release.

```bash
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_AWS
helm upgrade --install fastapi-app-canary ./helm/fastapi-app -n default \
    --set image.repository=<aws-account-id>.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME \
    --set image.tag=$CI_COMMIT_SHA \
    --set replicaCount=1

gcloud container clusters get-credentials $CLUSTER_GCP --region $GCP_REGION --project $GCP_PROJECT
helm upgrade --install fastapi-app-canary ./helm/fastapi-app -n default \
    --set image.repository=$GCP_REGION-docker.pkg.dev/$GCP_PROJECT/$IMAGE_NAME \
    --set image.tag=$CI_COMMIT_SHA \
    --set replicaCount=1
