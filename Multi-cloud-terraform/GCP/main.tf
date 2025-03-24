# VPC Configuration
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "3.3.0"

  name       = "gcp-vpc"
  project_id = var.project_id
  network    = "gcp-network"
  subnets = [
    {
      subnet_name   = "gcp-private-subnet"
      subnet_ip     = "10.2.0.0/24"
      subnet_region = "us-central1"
    }
  ]
}

# GKE Cluster
module "gke" {
  source            = "terraform-google-modules/kubernetes-engine/google"
  project_id        = var.project_id
  name              = "gke-cluster"
  region            = "us-central1"
  network           = module.vpc.network
  subnetwork        = module.vpc.subnets[0].subnet_name
  ip_range_pods     = "10.3.0.0/16"
  ip_range_services = "10.4.0.0/16"
  node_pools = [
    {
      name       = "default-pool"
      machine_type = "e2-medium"
      node_count  = 3
    }
  ]
}

# HTTP Load Balancer
resource "google_compute_global_address" "lb_address" {
  name = "gcp-lb-address"
}

resource "google_compute_backend_service" "main" {
  name                  = "gcp-backend-service"
  protocol              = "HTTP"
  health_checks         = [google_compute_health_check.main.self_link]
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_url_map" "main" {
  name            = "gcp-url-map"
  default_service = google_compute_backend_service.main.self_link
}

resource "google_compute_target_http_proxy" "main" {
  name   = "gcp-http-proxy"
  url_map = google_compute_url_map.main.self_link
}

resource "google_compute_global_forwarding_rule" "main" {
  name       = "gcp-forwarding-rule"
  target     = google_compute_target_http_proxy.main.self_link
  port_range = "80"
  ip_address = google_compute_global_address.lb_address.address
}