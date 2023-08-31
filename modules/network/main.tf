#Create VPC and IGW, attach IGW to VPC
resource "aws_vpc" "word-press-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "word-press-IGW" {
  vpc_id = aws_vpc.word-press-vpc.id
  tags = {
    Name: "${var.env_prefix}-IGW"
  }
}

# resource "aws_internet_gateway_attachment" "attach-IGW" {
#   internet_gateway_id = aws_internet_gateway.word-press-IGW.id
#   vpc_id              = aws_vpc.word-press-vpc.id
# }

#Create public subnet 1 in AZ1
resource "aws_subnet" "public-subnet-1"{
    vpc_id = aws_vpc.word-press-vpc.id
    cidr_block = var.public_subnet_1_cidr_block
    availability_zone = var.az_1
    map_public_ip_on_launch = true
    tags = {
        Name: "${var.env_prefix}-public-subnet-1"
    }
}

#Create public subnet 2 in AZ2
resource "aws_subnet" "public-subnet-2"{
    vpc_id = aws_vpc.word-press-vpc.id
    cidr_block = var.public_subnet_2_cidr_block
    availability_zone = var.az_2
    map_public_ip_on_launch = true
    tags = {
        Name: "${var.env_prefix}-public-subnet-2"
    }
}

#Create application subnet 1 in AZ1
resource "aws_subnet" "app-subnet-1"{
    vpc_id = aws_vpc.word-press-vpc.id
    cidr_block = var.app_subnet_1_cidr_block
    availability_zone = var.az_1
    map_public_ip_on_launch = false
    tags = {
        Name: "${var.env_prefix}-app-subnet-1"
    }
}

#Create application subnet 2 in AZ2
resource "aws_subnet" "app-subnet-2"{
    vpc_id = aws_vpc.word-press-vpc.id
    cidr_block = var.app_subnet_2_cidr_block
    availability_zone = var.az_2
    map_public_ip_on_launch = false
    tags = {
        Name: "${var.env_prefix}-app-subnet-2"
    }
}

#Create database subnet 1 in AZ1
resource "aws_subnet" "database-subnet-1"{
    vpc_id = aws_vpc.word-press-vpc.id
    cidr_block = var.database_subnet_1_cidr_block
    availability_zone = var.az_1
    map_public_ip_on_launch = false
    tags = {
        Name: "${var.env_prefix}-database-subnet-1"
    }
}

#Create database subnet 2 in AZ2
resource "aws_subnet" "database-subnet-2"{
    vpc_id = aws_vpc.word-press-vpc.id
    cidr_block = var.database_subnet_2_cidr_block
    availability_zone = var.az_2
    map_public_ip_on_launch = false
    tags = {
        Name: "${var.env_prefix}-database-subnet-2"
    }
}

#Elastic ip 1 for Nat Gateway 1
resource "aws_eip" "elastic-ip-1"{
    domain = "vpc"
    tags = {
        Name: "${var.env_prefix}-elastic-ip-1"
    }
}

#Create Nat Gateway 1 in Public Subnet 1
resource "aws_nat_gateway" "natgateway-1"{
    subnet_id = aws_subnet.public-subnet-1.id
    allocation_id = aws_eip.elastic-ip-1.id
    tags = {
        Name: "${var.env_prefix}-Natgateway-1"
    }
}

#Elastic ip 2 for Nat Gateway 2
resource "aws_eip" "elastic-ip-2"{
    domain = "vpc"
    tags = {
        Name: "${var.env_prefix}-elastic-ip-2"
    }
}

#Create Nat Gateway 2 in Public Subnet 2
resource "aws_nat_gateway" "natgateway-2"{
    subnet_id = aws_subnet.public-subnet-2.id
    allocation_id = aws_eip.elastic-ip-2.id
    tags = {
        Name: "${var.env_prefix}-Natgateway-2"
    }
}

# Routing:

#Public Route Table
resource "aws_route_table" "public-route-table"{
    vpc_id = aws_vpc.word-press-vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.word-press-IGW.id
    }
     tags = {
        Name: "${var.env_prefix}-public-rtb"
    }   
}

#Private Route Table in AZ1
resource "aws_route_table" "private-route-table-az1"{
    vpc_id = aws_vpc.word-press-vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.natgateway-1.id
    }
     tags = {
        Name: "${var.env_prefix}-private-rtb-az1"
    }   
}

#Private Route Table in AZ2
resource "aws_route_table" "private-route-table-az2"{
    vpc_id = aws_vpc.word-press-vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.natgateway-2.id
    }
     tags = {
        Name: "${var.env_prefix}-private-rtb-az2"
    }   
}

#Subnet Association with Routes:

resource "aws_route_table_association" "public-subnet1-rtb-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-subnet2-rtb-association" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private-app-subnet1-rtb-association" {
  subnet_id      = aws_subnet.app-subnet-1.id
  route_table_id = aws_route_table.private-route-table-az1.id
}

resource "aws_route_table_association" "private-database-subnet1-rtb-association" {
  subnet_id      = aws_subnet.database-subnet-1.id
  route_table_id = aws_route_table.private-route-table-az1.id
}

resource "aws_route_table_association" "private-app-subnet2-rtb-association" {
  subnet_id      = aws_subnet.app-subnet-2.id
  route_table_id = aws_route_table.private-route-table-az2.id
}

resource "aws_route_table_association" "private-database-subnet2-rtb-association" {
  subnet_id      = aws_subnet.database-subnet-2.id
  route_table_id = aws_route_table.private-route-table-az2.id
}

