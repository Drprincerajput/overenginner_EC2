provider "aws" {
  region = "us-east-1" # Replace as needed
}

resource "aws_s3_bucket" "tfstate" {
  bucket        = "ec2-oe-terraform-state-prince"
  force_destroy = true

  tags = {
    Name        = "Terraform Remote State"
    Environment = "shared"
  }
}

resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "lock_table" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "shared"
  }
}
