provider "aws" {
  region = "ap-southeast-1"
}

# Creating VPC,name, CIDR and Tags
resource "aws_vpc" "dev" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "dev"
  }
}

# Creating Public Subnets in VPC
resource "aws_subnet" "dev-public-1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name = "dev-public-1"
  }
}

# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "dev-gw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev"
  }
}

# Creating Route Tables for Internet gateway
resource "aws_route_table" "dev-public" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw.id
  }

  tags = {
    Name = "dev-public-1"
  }
}

# Creating Route Associations public subnets
resource "aws_route_table_association" "dev-public-1-a" {
  subnet_id      = aws_subnet.dev-public-1.id
  route_table_id = aws_route_table.dev-public.id
}


# Creating Security Group using Terraform

resource "aws_security_group" "ssh" {
  name = "ssh-grp"
  description = "Allow HTTP and SSH traffic via Terraform"
  vpc_id = aws_vpc.dev.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

# Creating EC2 instances in public subnets
resource "aws_instance" "webserver" {
  ami = "ami-04ff9e9b51c1f62ca"
  instance_type = "t3.small"
  key_name = "triviapp_key"
  subnet_id = "${aws_subnet.dev-public-1.id}"
  vpc_security_group_ids = [aws_security_group.ssh.id]
  associate_public_ip_address = true
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
    delete_on_termination = true
  }
 user_data = "${file("userdata.sh")}"
 tags = {
    Name = "Triviapp"
  }
}