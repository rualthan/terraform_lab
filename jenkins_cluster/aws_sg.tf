# Fetch default VPC
data "aws_vpc" "default_vpc" {
  default = true
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow inbound traffic for Jenkins all outbound traffic"
  vpc_id      = data.aws_vpc.default_vpc.id

  tags = {
    # Tag with the name of the module dir
    # Easy to identify in AWS
    Name = "${basename(path.cwd)}"
  }
}


resource "aws_vpc_security_group_ingress_rule" "jenkins_sg_ssh" {
  security_group_id = aws_security_group.jenkins_sg.id
  # Your public IP 
  cidr_ipv4   = var.my_public_ip
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_sg_8080" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = var.my_public_ip
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_outbound" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_outbound" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}