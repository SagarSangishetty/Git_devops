resource "aws_key_pair" "example" {
  key_name   = "terraform-demo-sagar"  # Replace with your desired key name
  public_key = file("e:/git/Git_devops/terraform/module_vpc/my-new-key.pub")  # Replace with the path to your public key file
}

resource "aws_vpc" "vpc-test" {
    cidr_block = "10.0.0.0/16"  
}

resource "aws_subnet" "subnet-test" {
    vpc_id = aws_vpc.vpc-test.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw-test" {
  vpc_id = aws_vpc.vpc-test.id
}

resource "aws_route_table" "rt-test" {
  vpc_id = aws_vpc.vpc-test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-test.id
  }
}

resource "aws_route_table_association" "rt-test" {
    subnet_id = aws_subnet.subnet-test.id
   
    route_table_id = aws_route_table.rt-test.id
}

resource "aws_security_group" "sg-test" {
    name = "web"
    vpc_id = aws_vpc.vpc-test.id

    ingress {
        description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "Web-sg"
  }
  }

resource "aws_instance" "server" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.micro"
  key_name      = aws_key_pair.example.id
  vpc_security_group_ids = [aws_security_group.sg-test.id]
  subnet_id              = aws_subnet.subnet-test.id

  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    private_key = file("e:/git/Git_devops/terraform/module_vpc/my-new-key")  # Replace with the path to your private key
    host        = self.public_ip
  }

  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo nohup python3 app.py &",
    ]
  }
}
