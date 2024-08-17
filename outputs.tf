output "vpc" {
    value = aws_vpc.Sandbox_vpc.id
}

output "vpc_cidr" {
    value = aws_vpc.Sandbox_vpc.id
  
}

output "public_subnets-1" {
    value = aws_subnet.Sandbox_Public_Subnet["0"].id
  
}
output "public_subnets-2" {
    value = aws_subnet.Sandbox_Public_Subnet["1"].id
  
}

output "private_subnets-1" {
    value = aws_subnet.Sandbox_Private_Subnet["0"].id
  
}
output "private_subnets-2" {
    value = aws_subnet.Sandbox_Private_Subnet["1"].id
  
}

output "Database_subnets-1" {
    value = aws_subnet.Sandbox_DB_Subnet["0"].id
  
}
output "Database_subnets-2" {
    value = aws_subnet.Sandbox_DB_Subnet["1"].id
  
}
output "IGW" {
    value = aws_internet_gateway.Sandbox_IGW.id
  
}
output "EIP" {
    value = aws_eip.Sandbox-EIP.id
  
}
output "NAT" {
    value = aws_nat_gateway.Nat-Gateway.id
  
}


#Staging VPC

output "Staging-vpc" {
    value = aws_vpc.Staging_vpc.id
}

output "Staging-vpc_cidr" {
    value = aws_vpc.Staging_vpc.id
  
}

output "Staging-public_subnets-1" {
    value = aws_subnet.Staging_Public_Subnet["0"].id
  
}
output "Staging-public_subnets-2" {
    value = aws_subnet.Staging_Public_Subnet["1"].id
  
}

output "Staging-private_subnets-1" {
    value = aws_subnet.Staging_Private_Subnet["0"].id
  
}
output "Staging-private_subnets-2" {
    value = aws_subnet.Staging_Private_Subnet["1"].id
  
}

output "Staging-Database_subnets-1" {
    value = aws_subnet.Sandbox_DB_Subnet["0"].id
  
}
output "Staging-Database_subnets-2" {
    value = aws_subnet.Staging_DB_Subnet["1"].id
  
}
output "Staging-IGW" {
    value = aws_internet_gateway.Staging_IGW.id
  
}

#TGW
output "TGW" {
    value = aws_ec2_transit_gateway.Hub-TGW.id
  
}

output "TGW_DB_attachment" {
    value = aws_ec2_transit_gateway_vpc_attachment.Sandbox-DB-Subnets.id
  
}