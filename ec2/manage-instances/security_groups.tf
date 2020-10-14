resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow inbound SSH from anywhere"
  }
}
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow inbound HTTP from load balancer"
  }
}
resource "aws_security_group" "outbound" {
  name        = "allow_outbound_traffic"
  description = "Allow outbound traffic anywhere"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}