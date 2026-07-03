resource "aws_instance" "terraform_example" {
  ami =var.ami_value
  instance_type =var.instance_type_value
}
