terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.65.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
  backend "s3" {
    bucket = "ban-iac-tf-persistance-states-sbox-bucket"
    key    = "ec2/bastion.tfstate"
    region = "us-east-1"
  } 
}

provider "aws" {
    #profile = "SBOX-D1"
}
