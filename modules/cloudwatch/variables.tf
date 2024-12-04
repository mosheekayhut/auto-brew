variable "event_rule_name" {
  description = "The name of the CloudWatch event rule"
  type        = string
}

variable "schedule_expression" {
  description = "The schedule expression for triggering the rule (e.g., rate(7 days))"
  type        = string
}

variable "ec2_instance_id" {
  description = "The ID of the EC2 instance to start"
  type        = string
}

variable "aws_region" {
  description = "AWS region where the resources are deployed"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "cloudwatch_role_name" {
  description = "The name of the IAM role for CloudWatch"
  type        = string
}
