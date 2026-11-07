output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "IDs of all subnets (public and private)"
  value       = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
}

output "health_check_url" {
  description = "Health check endpoint URL for DR monitoring"
  value       = "https://${aws_vpc.main.id}.example.com/health"
}

output "backend_bucket" {
  description = "S3 bucket name for Terraform state (set manually)"
  value       = var.aws_region
}

output "dynamodb_table" {
  description = "DynamoDB table name for Terraform state locking (set manually)"
  value       = var.aws_region
}
