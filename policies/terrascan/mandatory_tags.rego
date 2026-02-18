package aws.tags

deny[msg] {
  resource := input.resource.aws_s3_bucket
  not resource.tags.Owner
  msg := "POLICY VIOLATION: S3 bucket must have an Owner tag"
}

deny[msg] {
  resource := input.resource.aws_s3_bucket
  not resource.tags.Environment
  msg := "POLICY VIOLATION: S3 bucket must have an Environment tag"
}

