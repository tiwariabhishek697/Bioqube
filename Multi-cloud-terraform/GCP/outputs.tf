output "gke_cluster_endpoint" {
  value = module.gke.endpoint
}

output "gcp_lb_ip" {
  value = google_compute_global_address.lb_address.address
}