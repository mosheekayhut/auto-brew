# AWS Region to deploy the infrastructure
variable "aws_region" {
  description = "AWS Region where the infrastructure will be deployed"
  type        = string
  default     = "us-east-1" # Change to your preferred AWS region if needed
}

# CIDR block allowed for SSH access to EC2 instance
variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed for SSH access to EC2 instances"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Replace with a specific range for better security
}

# AMI ID for the EC2 instance
variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

# Name of the S3 bucket for Terraform state
variable "bucket_name" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
}

# EC2 instance type
variable "instance_type" {
  description = "The type of the EC2 instance"
  type        = string
  default     = "m5.large" # Choose an instance type based on your workload
}

# Size of the EBS volume for the EC2 instance in GB
variable "volume_size" {
  description = "The size of the root EBS volume for the EC2 instance in GB"
  type        = number
  default     = 500
}

# Key pair name for SSH access to EC2 instances
variable "key_name" {
  description = "The name of the key pair to enable SSH access to EC2 instances"
  type        = string
  default     = "my-key" # Replace with your existing key pair name
}

# Tags to apply to all resources
variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "Development"
    Project     = "Homebrew Mirror"
  }
}

variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
}


variable "security_group_name" {
  description = "The name of the security group"
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "instance_profile_name" {
  description = "The name of the IAM instance profile"
  type        = string
}
