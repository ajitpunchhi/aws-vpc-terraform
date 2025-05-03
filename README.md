AWS VPC Terraform Module
This Terraform module creates a production-ready Amazon Web Services (AWS) Virtual Private Cloud (VPC) infrastructure with public, private, and database subnets across multiple Availability Zones.

![aws-vpc-architecture-diagram](https://github.com/user-attachments/assets/89bb1bdd-72d1-4004-a871-9e792b24e0f2)

Architecture Overview
This module creates a complete VPC infrastructure in the AWS Mumbai (ap-south-1) region with the following components:

VPC: 20.0.0.0/24 CIDR block with DNS hostnames and DNS support enabled
Internet Gateway: For public subnet internet access
NAT Gateway: Enables private subnet resources to access the internet
Elastic IP: Associated with the NAT Gateway
Subnets:

2 Public Subnets (20.0.0.0/26, 20.0.0.64/26)
2 Private Subnets (20.0.0.128/27, 20.0.0.160/27)
2 Database Subnets (20.0.0.192/27, 20.0.0.224/27)


Route Tables: Separate routing tables for public, private, and database subnets
High Availability: Resources are spread across two Availability Zones (ap-south-1a, ap-south-1b)

Features

✅ Production-ready VPC infrastructure
✅ Multi-AZ deployment for high availability
✅ Separate subnet tiers for different workload types
✅ NAT Gateway for private subnet outbound connectivity
✅ Configurable CIDR blocks and subnet layouts
✅ Comprehensive output values for integration
✅ Cost-optimized design with minimal required resources

