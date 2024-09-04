data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "input" {
  bucket = "${var.companycode}-${var.bucket_name_input}-${lower(terraform.workspace)}"
  tags = var.tags
  force_destroy = true
  lifecycle {
    create_before_destroy = true
  }
  
}

resource "aws_s3_bucket_versioning" "versioning_input" {
  bucket = aws_s3_bucket.input.id
  versioning_configuration {
    status = var.bucket_versioning_input == true ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-lifecycle-input" {
  bucket = aws_s3_bucket.input.id

  rule {
    id = "BAN Rules"

    expiration {
      days = 730
    }

    status = var.bucket_lifecycle_input == true ? "Enabled" : "Disabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    transition {
      days          = 365
      storage_class = "DEEP_ARCHIVE"
    }
    
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket_policy" "allow_ssl_requests_only-input" {
  bucket = aws_s3_bucket.input.id
  policy = jsonencode({
     "Version" : "2012-10-17",
     "Statement": [
        {
            "Sid": "AllowSSLRequestsOnly",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.input.arn}",
                "${aws_s3_bucket.input.arn}/*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
 })
 lifecycle {
    create_before_destroy = true
  }
} 


resource "aws_s3_bucket_public_access_block" "block-input" {
  bucket = aws_s3_bucket.input.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  lifecycle {
    create_before_destroy = true
  }
} 