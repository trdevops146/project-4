terraform {
    required_providers {
        source = "hashicorp/aws"
        version = "~>5.92"
    }
    required_version = ">=1.2"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "terraform_server" {
    instance_type = "t2.micro"
    ami = "ami-08a6efd148b1f7504"

}
