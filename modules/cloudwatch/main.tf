# CloudWatch Event Rule for Weekly Schedule
resource "aws_cloudwatch_event_rule" "weekly_trigger" {
  name                = var.event_rule_name
  description         = "Weekly trigger for starting Homebrew EC2 Instance"
  schedule_expression = var.schedule_expression
}

# CloudWatch Event Target for Lambda Function
resource "aws_cloudwatch_event_target" "ec2_start" {
  rule      = aws_cloudwatch_event_rule.weekly_trigger.name
  target_id = "StartEC2Instance"
  arn       = aws_lambda_function.start_ec2.arn
  input     = jsonencode({
    instance_id = var.ec2_instance_id,
    region      = var.aws_region
  })
}

# IAM Role for Lambda Function
resource "aws_iam_role" "cloudwatch_event_role" {
  name               = var.cloudwatch_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for starting EC2 instances
resource "aws_iam_policy" "lambda_ec2_policy" {
  name   = "lambda-ec2-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ec2:StartInstances",
          "ec2:DescribeInstances"
        ],
        Resource = "arn:aws:ec2:${var.aws_region}:${var.account_id}:instance/${var.ec2_instance_id}"
      }
    ]
  })
}

# Attach the EC2 policy to the Lambda Role
resource "aws_iam_role_policy_attachment" "attach_lambda_ec2_policy" {
  role       = aws_iam_role.cloudwatch_event_role.name
  policy_arn = aws_iam_policy.lambda_ec2_policy.arn
}

# Lambda Function for starting EC2 instance
resource "aws_lambda_function" "start_ec2" {
  filename         = "${path.module}/start_ec2.zip"
  function_name    = "start-ec2-instance"
  role             = aws_iam_role.cloudwatch_event_role.arn
  handler          = "start_ec2.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("${path.module}/start_ec2.zip")
  
  environment {
    variables = {
      INSTANCE_ID = var.ec2_instance_id
      REGION      = var.aws_region
    }
  }
}

# Allow EventBridge to invoke the Lambda Function
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_ec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.weekly_trigger.arn
}
