# terraform-aws-nat-instance [![CircleCI](https://circleci.com/gh/int128/terraform-aws-nat-instance.svg?style=shield)](https://circleci.com/gh/int128/terraform-aws-nat-instance)

This is a Terraform module to provision a NAT instance for private subnet(s).
It provides the following features:

- Auto healing using the ASG
- Lower cost using a spot instance
- Fixed public IP address using an EIP and ENI
- SSM session manager support


## Getting Started

```tf
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name                 = "hello-vpc"
  cidr                 = "172.18.0.0/16"
  private_subnets      = ["172.18.64.0/20", "172.18.80.0/20", "172.18.96.0/20"]
  public_subnets       = ["172.18.128.0/20", "172.18.144.0/20", "172.18.160.0/20"]
  enable_dns_hostnames = true
}

module "nat" {
  source = "int128/nat-instance/aws"

  name                        = "hello-nat"
  vpc_id                      = module.vpc.vpc_id
  public_subnet               = module.vpc.public_subnets[0]
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks

  # (Optional)
  # you can specify this to set the default route to the ENI in the route tables
  private_route_table_ids = module.vpc.private_route_table_ids
}
```


## How it works

Take a look at the diagram:

![diagram](diagram.svg)

This module provisions the following resources:

- Launch Template
- Auto Scaling Group with miexed instances policy
- Elastic IP
- Elastic Network Interface
- Security Group (allow from private subnets and to Internet)
- IAM Role for SSM and ENI attachment
- VPC Route (optional)

The auto scaling group will create an instance.

The instance does the following things on startup:

1. Attach the ENI to `eth1`.
1. Enable IP forwarding.
1. Set to ignore ICMP redirect packets.
1. Enable IP masquerade.
1. Switch the default route to `eth1`.

See [init.sh](data/init.sh) for more.


## TODOs

- [ ] Outputs
- [x] Variables descriptions
- [ ] CI
- [x] Parameters list in README.md


## Contributions

This is an open source software. Feel free to open issues and pull requests.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| image\_id | AMI of the NAT instance | string | `"ami-04b762b4289fba92b"` | no |
| instance\_types | Candidates of instance type of the NAT instance | list | `<list>` | no |
| key\_name | Name of the key pair for the NAT instance | string | `""` | no |
| name | Name of this NAT instance | string | n/a | yes |
| private\_route\_table\_ids | List of ID of the route tables for the private subnets. You set this to assign the each default route to the NAT instance | list | `<list>` | no |
| private\_subnets\_cidr\_blocks | List of CIDR blocks of the private subnets | string | n/a | yes |
| public\_subnet | ID of the public subnet for the NAT instance | string | n/a | yes |
| vpc\_id | ID of the VPC | string | n/a | yes |

