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
data "template_file" "httpd" {
  template = file("external/install_apache.sh")
}
resource "aws_instance" "httpd" {
  for_each          = var.instances
  ami               = data.aws_ami.amazon_linux_2.id
  availability_zone = each.value.availability_zone
  instance_type     = each.value.instance_type
  key_name          = each.value.key_name
  security_groups   = each.value.security_groups
  tags              = each.value.tags
  user_data         = data.template_file.httpd.rendered
}
output "public_dns" {
  value = {
    for instance in aws_instance.httpd :
    instance.tags.Name => instance.public_dns
  }
}