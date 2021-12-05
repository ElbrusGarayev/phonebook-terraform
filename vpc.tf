resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "VPC"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_subnet" "public-subnet-1" {
  cidr_block = var.public-subnet-1-cidr
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet 1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  cidr_block = var.public-subnet-2-cidr
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet 2"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id= aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_subnet" "private-subnet-1" {
  cidr_block = var.private-subnet-1-cidr
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = false

  tags = {
      Name = "Private Subnet 1 | App Tier "
  }
}

resource "aws_subnet" "private-subnet-2" {
  cidr_block = var.private-subnet-2-cidr
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet 2 | App Tier "
  }
}

resource "aws_subnet" "private-subnet-3" {
  cidr_block = var.private-subnet-3-cidr
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet 3 | Database Tier "
  }
}

resource "aws_subnet" "private-subnet-4" {
  cidr_block = var.private-subnet-4-cidr
  vpc_id     = aws_vpc.vpc.id
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet 4 | Database Tier "
  }
}
