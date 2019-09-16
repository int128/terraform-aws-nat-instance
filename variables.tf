variable "name" {
  description = "Name for all the resources as identifier"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "public_subnet" {
  description = "ID of the public subnet to place the NAT instance"
}

variable "private_subnets_cidr_blocks" {
  description = "List of CIDR blocks of the private subnets. The NAT instance accepts connections from this subnets"
}

variable "private_route_table_ids" {
  description = "List of ID of the route tables for the private subnets. You can set this to assign the each default route to the NAT instance"
  default     = []
}

variable "image_id" {
  description = "AMI of the NAT instance. Default to the latest Amazon Linux 2"
  default     = ""
}

variable "instance_types" {
  description = "Candidates of spot instance type for the NAT instance. This is used in the mixed instances policy"
  default     = ["t3.nano", "t3a.nano"]
}

variable "key_name" {
  description = "Name of the key pair for the NAT instance. You can set this to assign the key pair to the NAT instance"
  default     = ""
}
