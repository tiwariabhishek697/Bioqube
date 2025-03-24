# Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# Route 53 Record for AWS ALB
resource "aws_route53_record" "aws_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "aws.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

# Route 53 Record for GCP Load Balancer
resource "aws_route53_record" "gcp_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "gcp.${var.domain_name}"
  type    = "A"
  alias {
    name                   = google_compute_global_address.lb_address.address
    zone_id                = "Z2FDTNDATAQYW2" # Replace with the correct zone ID for GCP
    evaluate_target_health = false
  }
}

# Weighted Record for Multi-Cloud Traffic Management
resource "aws_route53_record" "weighted_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"

  weighted_routing_policy {
    weight = var.aws_weight
  }

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }

  weighted_routing_policy {
    weight = var.gcp_weight
  }

  alias {
    name                   = google_compute_global_address.lb_address.address
    zone_id                = "Z2FDTNDATAQYW2" # Replace with the correct zone ID for GCP
    evaluate_target_health = false
  }
}