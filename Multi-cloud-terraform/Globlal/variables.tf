variable "domain_name" {
  description = "The domain name for Route 53"
  default     = "example.com" # Replace with your domain name
}

variable "aws_weight" {
  description = "Traffic weight for AWS"
  default     = 50
}

variable "gcp_weight" {
  description = "Traffic weight for GCP"
  default     = 50
}