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

resource "aws_s3_bucket" "bucket-test" {
  bucket = "bucket-01092024"

  tags = {
    name = "my-bucket-list"
    Environment = "Dev"
  }
}