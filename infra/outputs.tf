output "bucket_name" {
  description = "Secure bucket name"
  value       = aws_s3_bucket.secure_bucket.bucket
}

# Just checking change`
