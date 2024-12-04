#resource "aws_dynamodb_table" "terraform_locks" {
#  name         = "terraform-brew-lock"
#  billing_mode = "PAY_PER_REQUEST"
#  hash_key     = "LockID"
#
#  attribute {
#    name = "LockID"
#    type = "S"
#  }
#
#  tags = {
#    Name = "Terraform Lock Table"
#    Environment = "Production"
#  }
#}


resource "aws_dynamodb_table" "main" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "PK" # Primary Key
    type = "S"  # String type
  }

  attribute {
    name = "SK" # Sort Key (אם דרוש)
    type = "S"
  }

  hash_key = "PK" # Primary Key name
  # אם יש לך Sort Key:
  range_key = "SK"

  tags = var.tags
}

