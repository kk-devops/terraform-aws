provider "aws" {
  region = var.region
}
resource "aws_network_interface" "management" {
  for_each = var.eni_instances
  subnet_id = each.value["subnet"]
  security_groups = [
    aws_security_group.allow_ssh_eni.id,
    aws_security_group.allow_http_eni.id,
    aws_security_group.outbound_eni.id
  ]
  attachment {
    instance = each.value["instance"]
    device_index = 1
  }
}
resource "aws_eip" "this" {
  for_each = toset(var.eip_network_interfaces)
  network_interface = each.key
  vpc      = true
}