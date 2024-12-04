# CloudWatch Module
module "cloudwatch" {
  source = "./modules/cloudwatch"

  event_rule_name      = "homebrew-weekly-trigger"
  schedule_expression  = "rate(7 days)"
  ec2_instance_id      = module.ec2.instance_id
  aws_region           = var.aws_region
  account_id           = data.aws_caller_identity.current.account_id
  cloudwatch_role_name = "homebrew-cloudwatch-role"
}

# S3 Module
module "s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
  tags        = var.tags
  account_id  = data.aws_caller_identity.current.account_id
  region      = var.aws_region
}

module "iam" {
  source = "./modules/iam"

  role_name     = var.role_name
  policy_name   = var.policy_name
  s3_bucket_arn = module.s3.bucket_arn
  instance_profile_name  = var.instance_profile_name
}


module "ec2" {
  source = "./modules/ec2"

  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  role_name            = var.role_name
  volume_size          = var.volume_size
  security_group_name  = var.security_group_name
  allowed_ssh_cidr     = var.allowed_ssh_cidr
  tags                 = var.tags
  iam_instance_profile = module.iam.iam_instance_profile
}


module "dynamodb" {
  source = "./modules/dynamodb"

  table_name = var.dynamodb_table_name
  tags       = var.tags
}

# AWS Caller Identity
data "aws_caller_identity" "current" {}
