# ALB

Configures simple application load balancer

First run:

```
terraform apply -target=module.ec2 
terraform apply
```

```"Alb"  = "true"``` will add instance to ```TargetGroup```