resource "aws_security_group" "allow_ssh_eni" {
  name        = "allow_ssh_eni"
  description = "Allow SSH inbound"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow inbound SSH from anywhere"
  }
}
resource "aws_security_group" "allow_http_eni" {
  name        = "allow_http_eni"
  description = "Allow HTTP inbound"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow inbound HTTP from anywhere"
  }
}
resource "aws_security_group" "outbound_eni" {
  name        = "allow_outbound_traffic_eni"
  description = "Allow outbound traffic anywhere"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}