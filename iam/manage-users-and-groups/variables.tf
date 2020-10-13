variable "keybase_profile" {}
variable "region" {}
variable "groups" {
  type = set(string)
}
variable "users" {
  type = set(string)
}
variable "group_memberships" {}
variable "policy_attachments" {}