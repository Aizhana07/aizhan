terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.20.1"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_instance" "web" {
  ami           = var.image_id
  instance_type = var.ec2_type
  vpc_security_group_ids = var.http_sg_id

  tags = {
    Name = "My-Terraform-Instance-1"
  }
}