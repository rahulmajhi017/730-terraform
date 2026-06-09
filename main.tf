# Resource main

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./module/vpc"
}

resource "aws_instance" "example" {
  ami           = var.instance_id
  instance_type = var.instance_type
  vpc_security_group_ids = [
    module.vpc.aws_security_group
  ]
  subnet_id = module.vpc.subnet1
  associate_public_ip_address = true 
  key_name = var.keyname
  tags = {
    Name = var.server_Name
  }
}

