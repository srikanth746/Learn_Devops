terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  access_key = "AKIAW5737UMMKBXECJEH"
  secret_key = "wkfhVQ4hk/gb5yJs1EGkbUioisGisuSJTerYjzAq"
}

resource "aws_s3_bucket" "bucket-example"{
  bucket = "mybucket"
}