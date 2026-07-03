module "aws_instance" {
  source = "./module_ec2"
ami_value        = "ami-0e86e20dae9224db8"
instance_type_value = "t2.micro"
}