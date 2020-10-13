variable "region" {
  default = "us-east-2"
}
variable "instances" {
  type = map(object({
    instance_type   = string
    key_name        = string
    security_groups = list(string)
    tags            = map(string)
  }))
}