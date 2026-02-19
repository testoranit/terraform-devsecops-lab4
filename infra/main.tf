############################################
# Secure Enterprise S3 Bucket (DevSecOps Lab)
############################################

# Main Secure Bucket
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "company-secure-data-${var.environment}"

  tags = {
    Owner       = var.owner
    Environment = var.environment
    CostCenter  = "FIN-001"
    JiraTicket  = "KAN-4"
  }
}

############################################
# Block All Public Access (Best Practice)
############################################

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

############################################
# Enable Versioning (Fix CKV_AWS_21)
############################################

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

############################################
# Enable KMS Encryption (Fix CKV_AWS_145)
############################################

resource "aws_s3_bucket_server_side_encryption_configuration" "kms_encryption" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

############################################
# Logging Bucket (Fix CKV_AWS_18)
############################################

resource "aws_s3_bucket" "log_bucket" {
  bucket = "company-access-logs-${var.environment}"

  tags = {
    Owner       = var.owner
    Environment = var.environment
    Purpose     = "AccessLogging"
  }
}

# Enable Logging for Secure Bucket
resource "aws_s3_bucket_logging" "logging" {
  bucket        = aws_s3_bucket.secure_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "secure-bucket-access/"
}

############################################
# Lifecycle Configuration (Fix CKV2_AWS_61)
############################################

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    id     = "archive-and-expire"
    status = "Enabled"

    # Move objects to cheaper storage after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Delete objects after 365 days (example retention policy)
    expiration {
      days = 365
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}


resource "aws_sns_topic" "bucket_notifications" {
  name              = "bucket-notifications"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.secure_bucket.id

  topic {
    topic_arn     = aws_sns_topic.bucket_notifications.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "logs/"
  }
}

############################################
# OPTIONAL: Event Notifications (Skipped)
# Fix CKV2_AWS_62 requires Lambda/SNS integration
############################################

# resource "aws_s3_bucket_notification" "notify" {
#   bucket = aws_s3_bucket.secure_bucket.id
# }

############################################
# OPTIONAL: Cross-Region Replication (Skipped)
# Fix CKV_AWS_144 requires IAM + destination bucket
############################################

# Replication is normally required only for prod DR

