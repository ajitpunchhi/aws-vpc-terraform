/*locals {
 tgw_name = "Multi-connection"
 sandbox_name = "Sandbox_vpc"
 staging_name = "Staging_vpc"
 Prod_name = "Prod_vpc"
 region = "ap-south-1"

 sandbox_vpc_cidr = "20.0.0.0/24"
 staging_vpc_cidr = "30.0.0.0/24"
 Prod_vpc_cidr    = "40.0.0.0/24"
 azs = slice(data.aws_availability_zones.availabile.names,0,3)

 staging_tags ={
    environment = local.staging_name
 }
  prod_tags ={
    environment = local.Prod_name
 }
  sandbox_tags ={
    environment = local.sandbox_name
 }

}
*/