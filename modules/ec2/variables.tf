variable "region" {
  default = "us-east-2"
}
variable "instances" {
  type = map(object({
    availability_zone      = string
    instance_type          = string
    key_name               = string
    vpc_security_group_ids = list(string)
    tags                   = map(string)
  }))
}