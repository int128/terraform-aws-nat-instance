# terraform-aws-nat-instance

This is a Terraform module which provisions a NAT instance using an auto scaling group and spot request.


## How it works

This provisions an EC2 instance for NAT.

The instance does the following things on startup:

1. Attach the ENI to `eth1`.
1. Enable IP forwarding.
1. Set to ignore ICMP redirect packets.
1. Enable IP masquerade.
1. Tear down `eth0`.

See [init.sh](data/init.sh) for more.
