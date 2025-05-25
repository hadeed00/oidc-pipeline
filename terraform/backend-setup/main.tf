provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "flask-devops-tf-state-447989883825-euw2-20240518"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "good_example" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
