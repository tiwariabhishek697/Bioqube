terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket" #  S3 bucket name
    key            = "multi-cloud/terraform.tfstate" # Path to the state file in the bucket
    region         = "us-east-1" # AWS region where the bucket is located
    encrypt        = true # Enable server-side encryption
    dynamodb_table = "terraform-lock-table" # DynamoDB table for state locking
  }
}