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
  description = "List of ID of the route tables for the private subnets. You set this to assign the each default route to the NAT instance"
  default     = []
}

variable "image_id" {
  description = "AMI of the NAT instance"
  # Amazon Linux 2 AMI (HVM), SSD Volume Type
  default = "ami-04b762b4289fba92b"
}

variable "instance_types" {
  description = "Candidates of instance type of the NAT instance"
  default     = ["t3.nano", "t3a.nano"]
}

variable "key_name" {
  description = "Name of the key pair for the NAT instance"
  default     = ""
}
