# Example of terraform-aws-nat-instance

Provision the stack.

```console
% terraform init

% terraform apply
...
Plan: 37 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
...
Apply complete! Resources: 37 added, 0 changed, 0 destroyed.
```

Make sure you can access an instance in the private subnet.

```console
% aws ssm start-session --region us-west-2 --target i-01d945b895167862a
```

You can completely destroy the stack.

```console
% terraform destroy
```
