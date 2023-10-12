variable "image_id" {
  type = string
  default = "ami-041feb57c611358bd"
}

variable "ec2_type" {
  type = string
  default = "t2.micro"
}

variable "http_sg_id" {
    type = list
    default = ["sg-054f5babc791aaf46"]  
}