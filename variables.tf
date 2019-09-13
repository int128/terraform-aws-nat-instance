variable "name" {
  description = "Name of this NAT instance"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "public_subnet" {
  description = "ID of the public subnet for the NAT instance"
}

variable "private_subnets_cidr_blocks" {
  description = "List of CIDR blocks of the private subnets"
}

variable "private_route_table_ids" {
  default = []
}

variable "image_id" {
  description = "AMI of the NAT instance"
  # amzn-ami-vpc-nat-hvm-2018.03.0.20181116-x86_64-ebs
  #default = "ami-0b840e8a1ce4cdf15"
  # Amazon Linux 2 AMI (HVM), SSD Volume Type
  default = "ami-04b762b4289fba92b"
}

variable "instance_types" {
  description = "Candidates of instance type of the NAT instance"
  default     = ["t3.nano", "t3a.nano"]
}

variable "key_name" {
}
