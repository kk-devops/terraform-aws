instances = {
  "web-1" = {
    availability_zone = "us-east-2a"
    instance_type     = "t2.micro"
    key_name          = "kkdo"
    security_groups = [
      "allow_ssh",
      "allow_http",
      "allow_outbound_traffic"
    ]
    tags = {
      "Name"          = "web-1"
      "AssignEip"     = "false"
      "HasAnotherEni" = "false"
      "Clb"           = "true"
    }
  }
  "web-2" = {
    availability_zone = "us-east-2a"
    instance_type     = "t2.micro"
    key_name          = "kkdo"
    security_groups = [
      "allow_ssh",
      "allow_http",
      "allow_outbound_traffic"
    ]
    tags = {
      "Name"          = "web-2"
      "AssignEip"     = "false"
      "HasAnotherEni" = "false"
      "Clb"           = "true"
    }
  }
  "web-3" = {
    availability_zone = "us-east-2b"
    instance_type     = "t2.micro"
    key_name          = "kkdo"
    security_groups = [
      "allow_ssh",
      "allow_http",
      "allow_outbound_traffic"
    ]
    tags = {
      "Name"          = "web-3"
      "AssignEip"     = "false"
      "HasAnotherEni" = "false"
      "Clb"           = "true"
    }
  }
}