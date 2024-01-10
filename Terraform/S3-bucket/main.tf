terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my-S3-bucket" {
  bucket = "my-s3-bucket"

  tags = {
    Name        = "My-bucket"
    Environment = "Dev"
  }
}