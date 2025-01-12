terraform {
  backend "s3" {
    bucket = "acs730-week4-dhana"                // Bucket where to SAVE Terraform State
    key    = "01-networking/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                           // Region where bucket is created
  }
}