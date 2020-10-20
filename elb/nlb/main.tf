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
        "Nlb"  = "true"
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
        "Nlb"  = "true"
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
        "Nlb"  = "true"
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
resource "aws_lb" "nlb" {
  name               = "nlb"
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.all.ids
}
resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.first.arn
  }
}
resource "aws_lb_target_group" "first" {
  name     = "tcpFirstTg"
  port     = "80"
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id
  health_check {
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }
}
resource "aws_lb_target_group_attachment" "tcp_first_tg" {
  for_each         = module.ec2.nlb_ids
  target_group_arn = aws_lb_target_group.first.arn
  target_id        = each.key
  port             = 80
}