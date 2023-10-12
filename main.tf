terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}



resource "aws_vpc" "tf-vpc-1" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "tf-vpc-1"
  }
}

resource "aws_subnet" "tf-subnet-a" {
  vpc_id                  = aws_vpc.tf-vpc-1.id
  cidr_block              = var.subnet_a
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-subnet-a"
  }
}


resource "aws_subnet" "tf-subnet-b" {
  vpc_id                  = aws_vpc.tf-vpc-1.id
  cidr_block              = var.subnet_b
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-subnet-b"
  }
}


#SECURITY GROUP WITH 22 OPEN PORT

resource "aws_security_group" "ssh_sg" {
  vpc_id = aws_vpc.tf-vpc-1.id
  name   = "ssh_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh_sg"
  }
}


resource "aws_security_group" "http_sg" {
  vpc_id = aws_vpc.tf-vpc-1.id
  name   = "http_sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "http_sg"
  }
}

#INTERNET GATEWAY

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf-vpc-1.id


  tags = {
    Name = "tf_igw"
  }

}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.tf-vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = "route_table"
  }
}

resource "aws_route_table_association" "rt-association-a" {
  subnet_id      = aws_subnet.tf-subnet-a.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "rt-association-b" {
  subnet_id      = aws_subnet.tf-subnet-b.id
  route_table_id = aws_route_table.route_table.id
}


#BASTION HOST

resource "aws_instance" "bastion_host" {
  ami                         = var.bastion_ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.ssh_sg.id]
  key_name                    = var.key
  subnet_id                   = aws_subnet.tf-subnet-a.id
  associate_public_ip_address = true

  tags = {
    Name = "bastion_host"
  }
}

#instance 

resource "aws_instance" "instance" {
  ami                         = var.bastion_ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.http_sg.id]
  key_name                    = var.key
  subnet_id                   = aws_subnet.tf-subnet-b.id
  associate_public_ip_address = true
  user_data                   = file("script.sh")

  tags = {
    Name = "instance"
  }
}
