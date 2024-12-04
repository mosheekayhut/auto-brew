variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "expiration_days" {
  description = "Number of days to retain noncurrent versions"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}
