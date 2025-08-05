terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = "us-east-1"
}

###create vpc####

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "rt1" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "rt_assoc_1" {
    route_table_id = aws_route_table.rt1.id
    subnet_id = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "rt_assoc_2" {
    route_table_id = aws_route_table.rt1.id
    subnet_id = aws_subnet.public_subnet_2.id
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket_prefix = "anubhav-terraform-project"
    
}

resource "aws_security_group" "sg1" {
  name_prefix = "project-sg"
  ingress {
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "TCP"
  }
  ingress {
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "TCP"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "project_instance_1" {
    ami = "ami-020cba7c55df1f615"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet_1.id
    vpc_security_group_ids = [ aws_security_group.sg1.id ]
}

resource "aws_instance" "project_instance_2" {
    ami = "ami-020cba7c55df1f615"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet_2.id
    vpc_security_group_ids = [ aws_security_group.sg1.id ]
}