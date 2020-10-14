# CLB

Configures simple classic load balancer

Apply tag ```"Clb" = "true"``` in ```../../ec2/dev.tfvars``` to instances you want in this load balancer

It's up to you to change security groups in ```../../ec2/manage-instances/security-groups.tf``` to accept incoming traffic only from load balancer. This is not mandatory, but something that makes sense. Add

```
data "aws_security_group" "clb" {
  name = "allow_http_clb"
}
```

and change ```cidr_blocks = ["0.0.0.0/0"]``` to ```security_groups = [data.aws_security_group.clb.id]```