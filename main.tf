# Create a Sandbox VPC in Mumbai Region 
resource "aws_vpc" "Sandbox_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = var.aws_true
  enable_dns_support = var.aws_true

tags = {
  Name = "Sandbox_vpc"
}  
}

#Create a Internet Gateway for Sandbox VPC 
resource "aws_internet_gateway" "Sandbox_IGW" {
  vpc_id = aws_vpc.Sandbox_vpc.id
  tags = {
    Name = "Sandbox_IGW"
  } 
}

#create a Public Subnets for the Sandbox VPC
resource "aws_subnet" "Sandbox_Public_Subnet" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.Sandbox_vpc.id
  cidr_block = element(var.public_subnets,count.index)
  availability_zone = element(var.region_azs,count.index)
  enable_resource_name_dns_a_record_on_launch = var.aws_true
  map_public_ip_on_launch = var.aws_true

  tags = {
    Name = "Sandbox_Public_Subnet ${count.index +1}"
  }
  
}

#create Route Table for the Public Subnets
resource "aws_route_table" "Sandbox_Public-RT" {
  vpc_id = aws_vpc.Sandbox_vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Sandbox_IGW.id
  }
tags = {
  Name = "Sandbox_Public-RT"
} 
}

# Associating Public Subnets with Sandbox-Public Route Table
resource "aws_route_table_association" "Public-RT" {
  count = length(var.public_subnets)
  route_table_id = aws_route_table.Sandbox_Public-RT.id
  subnet_id = element(aws_subnet.Sandbox_Public_Subnet[*].id,count.index)  
}

#creat a Public EIP for the Nat Gateway
resource "aws_eip" "Sandbox-EIP" {
  domain = "vpc"
  tags = {
    Name = "Sandbox-EIP"
  }  
}

#Attaching Public with VPC & Subnet
resource "aws_nat_gateway" "Nat-Gateway" {
  allocation_id = aws_eip.Sandbox-EIP.id
  subnet_id = aws_subnet.Sandbox_Public_Subnet["0"].id
}

#create a Private Subnets for the Sandbox VPC
resource "aws_subnet" "Sandbox_Private_Subnet" {
  vpc_id = aws_vpc.Sandbox_vpc.id
  count = length(var.private_subnets)
  cidr_block = element(var.private_subnets,count.index)
  availability_zone = element(var.region_azs,count.index)
  enable_resource_name_dns_a_record_on_launch = var.aws_true

  tags = {
    Name = "Sandbox_Private_Subnet ${count.index +1}"
  } 
}



#create a Route table for the Private Subnet
resource "aws_route_table" "Sandbox_Private-RT" {
  vpc_id = aws_vpc.Sandbox_vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.Nat-Gateway.id
  }
  tags = {
    Name = "Sandbox_Private-RT"
  }
}

#Assocating Subnets with Private Route Table
resource "aws_route_table_association" "Private-RT" {
  count = length(var.private_subnets)
  route_table_id = aws_route_table.Sandbox_Private-RT.id
  subnet_id = element(aws_subnet.Sandbox_Private_Subnet[*].id,count.index)
  
}

#create a DB Subnets for the Sandbox VPC
resource "aws_subnet" "Sandbox_DB_Subnet" {
  vpc_id = aws_vpc.Sandbox_vpc.id
  count = length(var.Database_subnets)
  cidr_block = element(var.Database_subnets,count.index)
  availability_zone = element(var.region_azs,count.index)
  enable_resource_name_dns_a_record_on_launch = var.aws_true

  tags = {
    Name = "Sandbox_Database_Subnet ${count.index +1}"
  } 
}

#create a Route table for the DB Subnet
resource "aws_route_table" "Sandbox_DB-RT" {
  vpc_id = aws_vpc.Sandbox_vpc.id
  tags = {
    Name = "Sandbox_DB-RT"
  }
}

#Assocating Subnets with DB Route Table
resource "aws_route_table_association" "DB-RT" {
  count = length(var.Database_subnets)
  route_table_id = aws_route_table.Sandbox_DB-RT.id
  subnet_id = element(aws_subnet.Sandbox_DB_Subnet[*].id,count.index) 
}