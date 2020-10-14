# EC2 classic

Use infrastructure.sh with *.tfvars file to create or destroy infrastructure

```./infrastructure.sh apply|destroy env.tfvars```

Instances defined in ```dev.tfvars```

Tag ```"AssignEip" = "true"``` will create and assign Elastic IP to first network interface on instance
Tag ```"HasAnotherEni" = "true``` = true will create additional network interface for instance