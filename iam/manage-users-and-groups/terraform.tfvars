region          = "us-east-2"
keybase_profile = "keybase:kkdo"
###################################################################################################################
users  = ["SomeGuy1", "SomeGuy2", "SomeGuy3"]
groups = ["admins", "managers"]
group_memberships = {
  "admins"   = ["SomeGuy1", "SomeGuy3"]
  "managers" = ["SomeGuy2", "SomeGuy3"]
}
policy_attachments = {
  "admins"   = ["AdministratorAccess"]
  "managers" = [
    "AmazonEC2ReadOnlyAccess",
    "AmazonS3ReadOnlyAccess"
  ]
}