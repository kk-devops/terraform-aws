provider "aws" {
  region = var.region
}
module "ec2" {
  source = "../../modules/ec2"
  instances = {
    "web-1" = {
      availability_zone = "us-east-2a"
      instance_type     = "t2.micro"
      key_name          = "kkdo"
      vpc_security_group_ids = [
        aws_security_group.allow_ssh.id,
        aws_security_group.allow_http.id,
        aws_security_group.outbound.id
      ]
      tags = {
        "Name" = "web-1"
        "Clb"  = "true"
      }
    }
    "web-2" = {
      availability_zone = "us-east-2a"
      instance_type     = "t2.micro"
      key_name          = "kkdo"
      vpc_security_group_ids = [
        aws_security_group.allow_ssh.id,
        aws_security_group.allow_http.id,
        aws_security_group.outbound.id
      ]
      tags = {
        "Name" = "web-2"
        "Clb"  = "true"
      }
    }
    "web-3" = {
      availability_zone = "us-east-2b"
      instance_type     = "t2.micro"
      key_name          = "kkdo"
      vpc_security_group_ids = [
        aws_security_group.allow_ssh.id,
        aws_security_group.allow_http.id,
        aws_security_group.outbound.id
      ]
      tags = {
        "Name" = "web-3"
        "Clb"  = "false"
      }
    }
  }
}
resource "aws_elb" "clb" {
  name = "clb"
  availability_zones = [
    "us-east-2a",
    "us-east-2b",
    "us-east-2c"
  ]
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
  instances = keys(module.ec2.clb_ids)
  security_groups = [
    aws_security_group.lb_sg.id,
    aws_security_group.outbound_lb.id
  ]
}