provider "aws" {
  region                  = "us-east-2"
  profile                 = "terraform-user"
}

resource "aws_eip" "two" {
  vpc = true
}

resource "aws_vpc" "prod" {
  cidr_block       = "192.168.0.0/19"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "My_VPC_Subnet" {
  vpc_id                  = aws_vpc.prod.id
  cidr_block              = "192.168.1.0/23"
  map_public_ip_on_launch = "true"
tags = {
   Name = "My VPC Subnet"
}
}

resource "aws_internet_gateway" "My_VPC_GW" {
 vpc_id = aws_vpc.prod.id
 tags = {
        Name = "My VPC Internet Gateway"
}
}

resource "aws_route_table" "My_VPC_route_table" {
 vpc_id = aws_vpc.prod.id
 tags = {
        Name = "My VPC Route Table"
}
}

resource "aws_route" "My_VPC_internet_access" {
  route_table_id         = aws_route_table.My_VPC_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.My_VPC_GW.id
}

resource "aws_route_table_association" "My_VPC_association" {
  subnet_id      = aws_subnet.My_VPC_Subnet.id
  route_table_id = aws_route_table.My_VPC_route_table.id
}

resource "aws_security_group" "My_VPC_Security_Group" {
  vpc_id       = aws_vpc.prod.id
  name         = "My VPC Security Group"
  description  = "My VPC Security Group"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ] 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "My VPC Security Group"
   Description = "My VPC Security Group"
}
}
