variable "region" {
  default = "us-east-2"
}
variable "eni_instances" {
  type = map(object({
    instance = string
    subnet = string
  }))
}
variable "eip_network_interfaces" {
  type = list(string)
}