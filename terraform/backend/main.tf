provider "aws" {
  region = "us-east-1"
} 


resource "aws_s3_bucket" "terraform_state" {
  bucket = "crud-terraform-eks-state-bucket"

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-eks-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}