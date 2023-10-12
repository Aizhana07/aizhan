######################################



variable "vpc_cidr" {
  type        = string
  description = "cidr block for vpc"
  #default = "10.0.0.0/16"
}

variable "subnet_a" {
  type = string
  #default = "10.0.1.0/24"
}




variable "subnet_b" {
  type = string
  #default = "10.0.2.0/24"
}



variable "bastion_ami" {
  type = string
  #default = "ami-041feb57c611358bd"

}

variable "instance_type" {
  type = string
  /* default = "t2.micro" */

}

variable "key" {
  type = string

}

