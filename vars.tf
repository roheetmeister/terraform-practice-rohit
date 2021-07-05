# Declare Variables

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "Choose cidr for your VPC"
  type        = string

}

# Declare a variable for Region
variable "region" {
  default = "us-east-2"
  type    = string

}

# Declare a variable for Instance type
variable "web_instance_type" {
  default = "t2.micro"
  type    = string

}

# Declare a variable for AMI
variable "web_ami" {
  default = {
  us-east-2 = "ami-0277b52859bac6f4b"
  us-south-1 = "ami-011c99152163a87ae"
  }
  type    = map(string)

}

variable "web_s3" {
  default = "kubernetes.bucket-dev"
  
}


