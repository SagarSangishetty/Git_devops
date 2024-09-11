resource "aws_instance" "terrform_example" {
  ami =var.ami_value
  instance_type =var.instance_type_value
}