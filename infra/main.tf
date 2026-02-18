# Secure S3 Bucket (Enterprise Standard)

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "company-secure-data-${var.environment}"

  tags = {
    Owner       = var.owner
    Environment = var.environment
    CostCenter  = "FIN-001"
  }
}

# Enforce Encryption (PCI-DSS Requirement)

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block Public Access (SOC2/HIPAA Control)

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

