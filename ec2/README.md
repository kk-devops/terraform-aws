# EC2 classic

Use infrastructure.sh with *.tfvars file to create or destroy infrastructure

```./infrastructure.sh apply|destroy env.tfvars```

Instances defined in ```dev.tfvars```

```"AssignEip" = "true"``` will create and assign Elastic IP to first network interface on instance

```"HasAnotherEni" = "true``` = true will create additional network interface for instance

```"Clb" = "true"``` will add instance to classic load balancer, which created in ```../elb/clb``` folder