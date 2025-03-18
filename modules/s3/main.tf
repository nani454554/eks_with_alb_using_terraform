resource "aws_s3_bucket" "log_bucket" {
  bucket = var.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "log_retention" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    id     = "log-retention"
    status = "Enabled"

    filter {
      prefix = "" # Apply rule to all objects in the bucket
    }

    expiration {
      days = 60
    }

     noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}


