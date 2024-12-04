resource "aws_s3_bucket" "homebrew_bucket" {
  bucket = var.bucket_name
  tags = var.tags
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.homebrew_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.homebrew_bucket.id

  rule {
    id     = "expire_old_versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.expiration_days
    }
  }
}

resource "aws_s3_bucket_policy" "homebrew_bucket_policy" {
  bucket = aws_s3_bucket.homebrew_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:root"
        },
        Action    = ["s3:PutObject", "s3:GetObject"],
        Resource  = [
          "arn:aws:s3:::${aws_s3_bucket.homebrew_bucket.id}/*"
        ]
      }
    ]
  })
}
