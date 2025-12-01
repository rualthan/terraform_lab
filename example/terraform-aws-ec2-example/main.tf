terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.23.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

variable "ami_id" {
  description = "To input the AMI ID"
  type        = string
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = "t2.micro"
}

output "public_ip" {
  description = "Public IP of the instance. Having a description is best practice."
  value       = aws_instance.example.public_ip
}