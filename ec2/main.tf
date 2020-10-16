provider "aws" {
  region = var.region
}
module "ec2" {
  source = "../modules/ec2"
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
        "Name"          = "web-1"
        "AssignEip"     = "true"
        "HasAnotherEni" = "false"
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
        "Name"          = "web-2"
        "AssignEip"     = "false"
        "HasAnotherEni" = "true"
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
        "Name"          = "web-3"
        "AssignEip"     = "true"
        "HasAnotherEni" = "true"
      }
    }
  }
}
resource "aws_network_interface" "management" {
  for_each  = module.ec2.eni_ids
  subnet_id = each.value
  security_groups = [
    aws_security_group.allow_ssh_eni.id,
    aws_security_group.allow_http_eni.id,
    aws_security_group.outbound_eni.id
  ]
  attachment {
    instance     = each.key
    device_index = 1
  }
}
resource "aws_eip" "this" {
  for_each          = module.ec2.eip_ids
  network_interface = each.value
  vpc               = true
}