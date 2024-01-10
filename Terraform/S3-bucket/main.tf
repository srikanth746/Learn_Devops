terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket_4467"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}