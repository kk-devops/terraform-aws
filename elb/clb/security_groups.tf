resource "aws_security_group" "lb_sg" {
  name        = "allow_http_clb"
  description = "Allow HTTP"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow inbound HTTP from anywhere"
  }
  tags = {
    Name = "allow_http_clb"
  }
}
resource "aws_security_group" "outbound" {
  name        = "allow_outbound_traffic_clb"
  description = "Allow outbound traffic anywhere"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
