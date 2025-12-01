
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.23.0"
    }
  }
}

resource "aws_key_pair" "my_key" {
  public_key = file(var.my_pub_key_path)
  key_name   = "my_kp"
}

provider "aws" {
  region = "us-east-1"
}


# Fetch Ubuntu 22.04 AMI ID
data "aws_ami" "ubuntu_22_04" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# Create the master node
resource "aws_instance" "jenkins_tomcat" {
  ami                    = data.aws_ami.ubuntu_22_04.id
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.jenkins_tomcat_sg.id]
  key_name               = aws_key_pair.my_key.key_name
  user_data              = file("setup.sh")
  tags = {
    # Tag with the name of the module dir
    # Easy to identify in AWS
    Name = "${basename(path.cwd)}"
  }

}

output "public_ip" {
  value = aws_instance.jenkins_tomcat.public_ip
}

