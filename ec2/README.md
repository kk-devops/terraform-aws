# EC2 classic

First run:

```
terraform apply -target=module.ec2 
terraform apply
```

```"AssignEip" = "true"``` will create and assign Elastic IP to first network interface on instance

```"HasAnotherEni" = "true"``` will create additional network interface for instance