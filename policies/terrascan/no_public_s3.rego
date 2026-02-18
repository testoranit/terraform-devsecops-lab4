package aws.s3

deny[msg] {
  resource := input.resource.aws_s3_bucket
  not input.resource.aws_s3_bucket_public_access_block
  msg := "POLICY VIOLATION: Public access must be blocked (SOC2/HIPAA)"
}

