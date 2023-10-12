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


resource "aws_vpc" "tf-vpc-1" {
  cidr_block       = var.vpc_id

  tags = {
    Name = "tf-vpc-1"
  }

}

resource "aws_subnet" "tf-subnet-a" {
  vpc_id     = aws_vpc.tf-vpc-1.id
  cidr_block = var.subnet_a
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-subnet-a"
  }
}

resource "aws_subnet" "tf-subnet-b" {
  vpc_id = aws_vpc.tf-vpc-1.id
  cidr_block = var.subnet_b
  availability_zone = "us-east-1a"


  tags = {
    Name = "tf-subnet-b"
  }
}