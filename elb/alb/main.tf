provider "aws" {
  region = var.region
}
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????.?-x86_64-gp2"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}
resource "aws_key_pair" "kkdo" {
  key_name   = "kkdo"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIfNhFcj+wxzq+JNxqGEAL7wTYcBXCh+XpR+ZUiehKuTQadgQ5xgLKqrbOVe0r1GCvAC8b0A5zSIIKtTUz7sf+kxr9JQ8W46pFiktG3nJ/EHElItiI0wZN7JKgT/8hpISQxSGSvuPU/BxIX/HEL02NyEkrBXuNN0S/iA+7fUOgBU5wZ4iYqrQoab7wqJEdgQjnbsSAFIO3TWejKqHMNT5JnHsCb9QlYjfHHMgpsRrwkBDIDZ060oDgBxsOj/TS48RnMyZhxoGKsHRZ9v8T+rJmrTwc/yeKy3NBbaZh+pwsVSUFsfK8G2UJL2fhaS2LZk1T824sAY+6dBkbVv6YQ6S44dozBCfdmlLUMBohClfpO4KQA/bkxb2jSUI6r4sreYyUzDzUqa39q+geED2JAO7m2jT5UvT1Dl858gYd+vZccmJOtoaIx9SBM2SylNvyyexRGCc/TntNzJLLUGRcjob8AKa9eRPvlboy1Ifcq/Dquay8iS7PDyMAGN0NhEJ7z6U= kk-devops@outlook.com"
}
resource "aws_autoscaling_group" "alb" {
  desired_capacity = 2
  min_size = 1
  max_size = 3
  name = "alb_asg"
  launch_template {
    name = aws_launch_template.httpd_template.name
  }
  vpc_zone_identifier = data.aws_subnet_ids.all.ids
  target_group_arns = [aws_lb_target_group.first.arn]
  health_check_type = "ELB"
}
resource "aws_autoscaling_policy" "cpu" {
  name = "track-cpu-usage"
  autoscaling_group_name = aws_autoscaling_group.alb.name
  estimated_instance_warmup = 10
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}
resource "aws_autoscaling_schedule" "friday_start" {
  autoscaling_group_name = aws_autoscaling_group.alb.name
  scheduled_action_name = "A lot of instances on Friday"
  recurrence = "0 0 * * FRI"
  desired_capacity = 10
  min_size = 10
  max_size = 10
}
resource "aws_autoscaling_schedule" "friday_end" {
  autoscaling_group_name = aws_autoscaling_group.alb.name
  scheduled_action_name = "Friday is over"
  recurrence = "0 0 * * SAT"
  desired_capacity = 2
  min_size = 1
  max_size = 3
}
resource "aws_launch_template" "httpd_template" {
  name = "httpd_template"
  description = "Launches httpd instances"
  image_id = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.kkdo.key_name
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_http.id,
    aws_security_group.outbound.id
  ]
  user_data = filebase64("external/install_apache.sh")
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
    target_group_arn = aws_lb_target_group.first.arn
  }
}
resource "aws_lb_target_group" "first" {
  name     = "httpFirstTg"
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
  stickiness {
    type = "lb_cookie"
    enabled = false
  }
}