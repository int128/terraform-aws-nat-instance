# Example of terraform-aws-nat-instance

This example shows the following things:

- Create a VPC and subnets using `vpc` module.
- Create a NAT instance using this module.
- Create an instance in the private subnet.
- Add custom scripts to the NAT instance.
  In this example, http port of the private instance will be exposed.


## Getting Started

Provision the stack.

```console
% terraform init
% terraform apply
...

Outputs:

nat_public_ip = 54.212.155.23
private_instance_id = i-07c076946c5142cdd
```

Make sure you have access to the instance in the private subnet.

```console
% aws ssm start-session --region us-west-2 --target i-07c076946c5142cdd
```

Make sure you can access http port of the NAT instance.

```console
% curl http://54.212.155.23
```

You can completely destroy the stack.

```console
% terraform destroy
```
