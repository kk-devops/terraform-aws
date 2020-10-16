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
        "Alb"  = "true"
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
        "Alb"  = "false"
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
        "Alb"  = "true"
      }
    }
  }
}
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}
resource "aws_lb" "alb" {
  name    = "alb"
  subnets = data.aws_subnet_ids.all.ids
  security_groups = [
    aws_security_group.lb_sg.id,
    aws_security_group.outbound_lb.id
  ]
}
resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}
resource "aws_lb_target_group" "http" {
  name     = "http"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = "200"
  }
}
resource "aws_lb_target_group_attachment" "http" {
  for_each         = module.ec2.alb_ids
  target_group_arn = aws_lb_target_group.http.arn
  target_id        = each.key
  port             = 80
}