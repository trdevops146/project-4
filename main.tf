terraform {
    required_providers {
        source = "hashicorp/aws"
        version = ">=5.9.2"
    }
    required_version = ">=1.2"
}

provider "aws" {
  region = "us-east-1"
}

