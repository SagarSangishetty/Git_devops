#main.tf in root directory

module "aws_instance" {
  source        = "./module_ec2"
  ami_value        = "ami-0e86e20dae9224db8"
  instance_type_value = "t2.micro"
}

output "public_ip_add" {
  value = module.aws_instance.public_ip_add
}
