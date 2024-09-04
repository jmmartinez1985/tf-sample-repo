output "arm_input" {
    value = aws_s3_bucket.input.arn
  
}

output "bucketname_input" {
    value = aws_s3_bucket.input.bucket
  
}

output "bucket_id" {
  value = aws_s3_bucket.input.id
}


output "account" {
  value = data.aws_caller_identity.current.account_id
}

