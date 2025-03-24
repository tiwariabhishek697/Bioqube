output "route53_zone_id" {
  description = "The ID of the Route 53 hosted zone"
  value       = aws_route53_zone.main.zone_id
}

output "global_accelerator_dns" {
  description = "The DNS name of the Global Accelerator"
  value       = aws_globalaccelerator_accelerator.main.dns_name
}

output "app_dns_name" {
  description = "The DNS name for the application"
  value       = "app.${var.domain_name}"
}