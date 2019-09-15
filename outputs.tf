output "eip_id" {
  description = "ID of the Elastic IP"
  value       = "${aws_eip.this.id}"
}

output "eip_public_ip" {
  description = "Public IP of the Elastic IP for the NAT instance"
  value       = "${aws_eip.this.public_ip}"
}

output "eni_id" {
  description = "ID of the ENI for the NAT instance"
  value       = "${aws_network_interface.this.id}"
}

output "sg_id" {
  description = "ID of the security group of the NAT instance"
  value       = "${aws_security_group.this.id}"
}

output "iam_role_name" {
  description = "Name of the IAM role for the NAT instance"
  value       = "${aws_iam_role.this.name}"
}
