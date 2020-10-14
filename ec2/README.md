# EC2 classic

Use infrastructure.sh to create or destroy infrastructure

Instances defined in ```dev.tfvars```

Tag ```"AssignEip" = "true"``` will create and assign Elastic IP to first network interface on instance
Tag ```"HasAnotherEni" = "true``` = true will create additional network interface for instance