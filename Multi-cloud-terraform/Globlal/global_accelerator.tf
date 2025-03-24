# AWS Global Accelerator
resource "aws_globalaccelerator_accelerator" "main" {
  name               = "multi-cloud-accelerator"
  enabled            = true
  ip_address_type    = "IPV4"
}

# Listener for Global Accelerator
resource "aws_globalaccelerator_listener" "main" {
  accelerator_arn = aws_globalaccelerator_accelerator.main.id
  protocol         = "TCP"
  port_ranges {
    from_port = 80
    to_port   = 80
  }
}

# Endpoint Group for AWS
resource "aws_globalaccelerator_endpoint_group" "aws" {
  listener_arn = aws_globalaccelerator_listener.main.id
  endpoint_configuration {
    endpoint_id = aws_lb.main.arn
    weight      = 50
  }

  health_check_path     = "/health"
  health_check_protocol = "HTTP"
  health_check_port     = 80
}

# Endpoint Group for GCP
resource "aws_globalaccelerator_endpoint_group" "gcp" {
  listener_arn = aws_globalaccelerator_listener.main.id
  endpoint_configuration {
    endpoint_id = google_compute_global_address.lb_address.address
    weight      = 50
  }

  health_check_path     = "/health"
  health_check_protocol = "HTTP"
  health_check_port     = 80
}