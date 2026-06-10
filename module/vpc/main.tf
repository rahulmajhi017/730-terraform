# VPC Module & Security Group

resource "aws_security_group" "sg" {
  name = "terraform-sg"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.ports

    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "TCP"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "terraform-sg"
    }
}

resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public1_cidr
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1a"
  tags = {
    Name = "public1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public2_cidr
  map_public_ip_on_launch = true
  availability_zone = "ap-south-1b"
  tags = {
    Name = "public2"
  }
}

resource "aws_subnet" "pvt-subnet1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private1_cidr
  availability_zone = "ap-south-1a"
  tags = {
    Name = "private1"
  }
}

resource "aws_subnet" "pvt-subnet2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private2_cidr
  availability_zone = "ap-south-1b"
  tags = {
    Name = "private2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat-igw" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.subnet1.id
  tags = {
    Name = "terraform-nat-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "terraform-rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt1" {
  route_table_id = aws_route_table.rt.id
  subnet_id = aws_subnet.subnet1.id
}

resource "aws_route_table_association" "rt2" {
  route_table_id = aws_route_table.rt.id
  subnet_id = aws_subnet.subnet2.id
}

resource "aws_route_table" "pvt-rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "terraform-pvt-rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-igw.id
  }
}

resource "aws_route_table_association" "pvt-rt1" {
  route_table_id = aws_route_table.pvt-rt.id
  subnet_id = aws_subnet.pvt-subnet1.id
}

resource "aws_route_table_association" "pvt-rt2" {
  route_table_id = aws_route_table.pvt-rt.id
  subnet_id = aws_subnet.pvt-subnet2.id
}

