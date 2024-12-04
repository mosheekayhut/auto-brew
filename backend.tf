terraform {
  backend "s3" {
    bucket         = "kayhut-terraform-state"
    key            = "auto-brew/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
