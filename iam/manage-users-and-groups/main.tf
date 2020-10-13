provider "aws" {
  region = var.region
}
locals {
  policy_attachments = flatten([
    for group, policies in var.policy_attachments : [
      for arn in policies : {
        group = group
        arn = "arn:aws:iam::aws:policy/${arn}"
      }
    ]
  ])
}
resource "aws_iam_user" "user" {
  for_each = var.users
  name     = each.key
}
resource "aws_iam_user_login_profile" "profile" {
  for_each = var.users
  user     = each.key
  pgp_key  = var.keybase_profile
}
resource "aws_iam_group" "groups" {
  for_each = var.groups
  name     = each.key
}
resource "aws_iam_group_membership" "this" {
  for_each   = var.group_memberships
  name       = each.key
  group      = each.key
  users      = each.value
  depends_on = [aws_iam_group.groups]
}
resource "aws_iam_group_policy_attachment" "this" {
  for_each = {
    for group_policy in local.policy_attachments :
    "${group_policy.group}.${group_policy.arn}" => group_policy
  }
  group      = each.value.group
  policy_arn = each.value.arn
}
output "passwords" {
  value = {
    for profile in aws_iam_user_login_profile.profile :
    profile.user => profile.encrypted_password
  }
}