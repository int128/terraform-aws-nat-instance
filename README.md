# terraform-aws-nat-instance [![CircleCI](https://circleci.com/gh/int128/terraform-aws-nat-instance.svg?style=shield)](https://circleci.com/gh/int128/terraform-aws-nat-instance)

This is a Terraform module to provision a NAT instance for private subnet(s).
It provides the following features:

- Auto healing using the ASG
- Lower cost using a spot instance
- Fixed public IP address using an EIP and ENI
- SSM session manager support

Take a look at the diagram:

![diagram](diagram.svg)

Note that you should use a NAT gateway in general.
This module is only for development or testing purpose.


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
  source = "github.com/int128/terraform-aws-nat-instance"

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
- [ ] Variables descriptions
- [ ] CI
- [ ] Parameters list in README.md


## Contributions

This is an open source software. Feel free to open issues and pull requests.
