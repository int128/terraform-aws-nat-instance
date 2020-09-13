provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "example"
  cidr                 = "172.18.0.0/16"
  azs                  = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets      = ["172.18.64.0/20", "172.18.80.0/20", "172.18.96.0/20"]
  public_subnets       = ["172.18.128.0/20", "172.18.144.0/20", "172.18.160.0/20"]
  enable_dns_hostnames = true
}

module "nat" {
  source = "../"

  name                        = "example"
  vpc_id                      = module.vpc.vpc_id
  public_subnet               = module.vpc.public_subnets[0]
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  private_route_table_ids     = module.vpc.private_route_table_ids

  # enable port forwarding (optional)
  user_data_write_files = [
    {
      path : "/opt/nat/dnat.sh",
      content : templatefile("./dnat.sh", { ec2_name = "example-terraform-aws-nat-instance" }),
      permissions : "0755",
    },
    {
      path : "/etc/systemd/system/dnat.service",
      content : file("./dnat.service"),
    },
  ]
  user_data_runcmd = [
    ["yum", "install", "-y", "jq"],
    ["systemctl", "enable", "dnat"],
    ["systemctl", "start", "dnat"],
  ]
}

resource "aws_eip" "nat" {
  network_interface = module.nat.eni_id
  tags = {
    "Name" = "nat-instance-example"
  }
}

# IAM policy for port forwarding (optional)
resource "aws_iam_role_policy" "dnat_service" {
  role   = module.nat.iam_role_name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# expose http port of the private instance (optional)
resource "aws_security_group_rule" "dnat_http" {
  description       = "expose HTTP service"
  security_group_id = module.nat.sg_id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

output "nat_public_ip" {
  value = aws_eip.nat.public_ip
}
