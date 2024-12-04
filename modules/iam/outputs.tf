output "iam_instance_profile" {
  description = "The name of the IAM instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.ec2_role.name
}
