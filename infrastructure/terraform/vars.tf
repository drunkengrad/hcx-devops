variable "env" {
  default = "dev"
}

variable "AWS_REGION" {
  default = "ap-south-1"
}
variable "AWS_PROFILE" {
  default = "target_hcx"
}

variable "instance_type" {
  default = "t3.large"
}

variable "ami" {
  default = "ami-0c1a7f89451184c8b"
}

variable "ec2" {
  type = map(string)
  default = {
    "kafka" = "t3.large",
  }
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "private_subnet" {
  type = set(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
}

variable "public_subnet" {
  type = string
  default =  "10.0.4.0/24"
}
