package aws.encryption

deny[msg] {
  resource := input.resource.aws_s3_bucket
  not input.resource.aws_s3_bucket_server_side_encryption_configuration
  msg := "POLICY VIOLATION: S3 bucket must enforce encryption (PCI-DSS)"
}

