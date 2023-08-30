# Create a VPC
resource "aws_vpc" "word-press-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "public-subnet-1"{
    vpc_id = aws_vpc.word-press-vpc.id
    cidr_block = var.public_subnet_1_cidr_block
    availability_zone = var.az_1
    map_public_ip_on_launch = true
    tags = {
        Name: "${var.env_prefix}-public-subnet-1"
    }
}
resource "aws_subnet" "public-subnet-2"{
    vpc_id = aws_vpc.word-press-vpc.id
    cidr_block = var.public_subnet_2_cidr_block
    availability_zone = var.az_2
    map_public_ip_on_launch = true
    tags = {
        Name: "${var.env_prefix}-public-subnet-2"
    }
}
resource "aws_subnet" "app-subnet-1"{
    vpc_id = aws_vpc.word-press-vpc.id
    cidr_block = var.app_subnet_1_cidr_block
    availability_zone = var.az_1
    map_public_ip_on_launch = false
    tags = {
        Name: "${var.env_prefix}-app-subnet-1"
    }
}
resource "aws_subnet" "app-subnet-2"{
    vpc_id = aws_vpc.word-press-vpc.id
    cidr_block = var.app_subnet_2_cidr_block
    availability_zone = var.az_2
    map_public_ip_on_launch = false
    tags = {
        Name: "${var.env_prefix}-app-subnet-2"
    }
}
resource "aws_subnet" "database-subnet-1"{
    vpc_id = aws_vpc.word-press-vpc.id
    cidr_block = var.database_subnet_1_cidr_block
    availability_zone = var.az_1
    map_public_ip_on_launch = false
    tags = {
        Name: "${var.env_prefix}-database-subnet-1"
    }
}

resource "aws_subnet" "database-subnet-2"{
    vpc_id = aws_vpc.word-press-vpc.id
    cidr_block = var.database_subnet_2_cidr_block
    availability_zone = var.az_2
    map_public_ip_on_launch = false
    tags = {
        Name: "${var.env_prefix}-database-subnet-2"
    }
}