provider "aws" {
  region = var.region
}
data "aws_instances" "clb" {
  instance_tags = {
    Clb = "true"
  }
}
resource "aws_elb" "clb" {
  name               = "clb"
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
  health_check {
    target              = "HTTP:80/"
    timeout             = 5
    interval            = 10
    unhealthy_threshold = 2
    healthy_threshold   = 5
  }
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  instances       = data.aws_instances.clb.ids
  security_groups = [aws_security_group.lb_sg.id, aws_security_group.outbound.id]
}