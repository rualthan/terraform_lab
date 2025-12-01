module ec2_example{
    source = "./terraform-aws-ec2-example"
    ami_id = "ami-0fa3fe0fa7920f68e"
}

output "public_ip" {
  description = "This is the public IP of the instance"
  value = module.ec2_example.public_ip
}