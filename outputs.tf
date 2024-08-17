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