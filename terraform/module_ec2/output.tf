output "public-ip-address" {
  value = aws_instance.terraform_example.public_ip
}