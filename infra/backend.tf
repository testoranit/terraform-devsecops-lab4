/* terraform {
  backend "s3" {
    bucket         = "my-org-terraform-state"
    key            = "devsecops/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

*/
