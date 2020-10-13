instances = {
  "web-1" = {
    instance_type = "t2.micro"
    key_name      = "kkdo"
    security_groups = [
      "allow_ssh",
      "allow_http",
      "allow_outbound_traffic"
    ]
    tags = {
      "Name"          = "web-1"
      "AssignEip"     = "false"
      "HasAnotherEni" = "true"
    }
  }
  "web-2" = {
    instance_type = "t2.micro"
    key_name      = "kkdo"
    security_groups = [
      "allow_ssh",
      "allow_http",
      "allow_outbound_traffic"
    ]
    tags = {
      "Name"          = "web-2"
      "AssignEip"     = "true"
      "HasAnotherEni" = "false"
    }
  }
}