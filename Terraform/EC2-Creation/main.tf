#Requesting terraform for the specific provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#Mentioned the required location
provider "aws"{
  region = "us-east-1"
}

#Creating the ec2 instance resource
resource "aws_instance" "example" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-ubuntu"
  }
}