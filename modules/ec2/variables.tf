variable "iam_instance_profile" {
  description = "The IAM instance profile to attach to the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair"
  type        = string
}


variable "volume_size" {
  description = "The root volume size for the EC2 instance"
  type        = number
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "The CIDR blocks allowed for SSH access"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to apply to the resources"
  type        = map(string)
}

variable "role_name" {
  description = "The name of the IAM role to attach to the EC2 instance"
  type        = string
}
