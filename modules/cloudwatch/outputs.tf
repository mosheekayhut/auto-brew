output "cloudwatch_event_rule_arn" {
  description = "The ARN of the CloudWatch event rule"
  value       = aws_cloudwatch_event_rule.weekly_trigger.arn
}

output "cloudwatch_role_arn" {
  description = "The ARN of the CloudWatch IAM role"
  value       = aws_iam_role.cloudwatch_event_role.arn
}
