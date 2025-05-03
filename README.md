AWS VPC Terraform Module
This Terraform module creates an Amazon Web Services (AWS) Virtual Private Cloud (VPC) along with subnets, route tables, and gateways. It provides an easy-to-use interface to set up a comprehensive network infrastructure in AWS.


![aws-vpc-architecture-diagram](https://github.com/user-attachments/assets/89bb1bdd-72d1-4004-a871-9e792b24e0f2)

```hcl
Features

1. Create a VPC with configurable CIDR block
2. Create public, private and DB subnets across multiple Availability Zones
3. Configure route tables for the subnets
4. Create an Internet Gateway (IGW) and associate it with the public route table
5. Create a NAT Gateway for private subnet outbound internet access
6. Support for extensible configuration for staging and production environments
A. utomatic DNS hostname and support configuration
8. Cross-AZ redundancy for high availability
```
Architecture
The module creates the following AWS resources:

VPC: Virtual private cloud with custom CIDR block
Subnets:

Public subnets: 2 subnets across AZs with public IP auto-assignment
Private subnets: 2 subnets across AZs
Database subnets: 2 isolated subnets for database resources


Internet Gateway: For public subnet internet access
NAT Gateway: For private subnet outbound internet access
Route Tables:

Public route table with internet gateway
Private route table with NAT gateway
Database route table (isolated)


Elastic IP: For NAT Gateway association

Prerequisites
Before using this Terraform module, ensure that you have the following installed:

Terraform >= 1.0.0
AWS CLI configured with appropriate credentials
An AWS account with the necessary permissions to create VPC resources

Usage
Quick Start
hclmodule "vpc" {
  source = "./path-to-module"
  
  aws_region     = "ap-south-1"
  vpc_cidr       = "20.0.0.0/24"
  public_subnets = ["20.0.0.0/26", "20.0.0.64/26"]
  
  # Add AWS credentials (not recommended for production)
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
}
Multiple Environment Support
The module includes configuration for staging environments:
hcl# Use staging variables
public_subnets_staging  = ["30.0.0.0/26", "30.0.0.64/26"]
private_subnets_staging = ["30.0.0.128/27", "30.0.0.160/27"]
Database_subnets_staging = ["30.0.0.192/27", "30.0.0.224/27"]
Complete Example
bash# Clone the repository
git clone https://github.com/yourusername/aws-vpc-terraform.git
cd aws-vpc-terraform

# Initialize Terraform
terraform init

# Create terraform.tfvars file
cat > terraform.tfvars << EOF
aws_region     = "ap-south-1"
vpc_cidr       = "20.0.0.0/24"
public_subnets = ["20.0.0.0/26", "20.0.0.64/26"]
private_subnets = ["20.0.0.128/27", "20.0.0.160/27"]
Database_subnets = ["20.0.0.192/27", "20.0.0.224/27"]
region_azs     = ["ap-south-1a", "ap-south-1b"]
EOF

# Plan the infrastructure
terraform plan

# Apply the configuration
terraform apply

# Clean up resources
terraform destroy
Input Variables
NameDescriptionTypeDefaultaws_regionAWS region to create resourcesstringap-south-1vpc_cidrCIDR block for VPCstring20.0.0.0/24public_subnetsList of public subnet CIDR blockslist(string)["20.0.0.0/26", "20.0.0.64/26"]private_subnetsList of private subnet CIDR blockslist(string)["20.0.0.128/27", "20.0.0.160/27"]Database_subnetsList of database subnet CIDR blockslist(string)["20.0.0.192/27", "20.0.0.224/27"]region_azsList of availability zoneslist(string)["ap-south-1a", "ap-south-1b"]aws_access_keyAWS access keystring""aws_secret_keyAWS secret keystring""
Outputs
NameDescriptionvpcThe ID of the VPCpublic_subnets-1ID of first public subnetpublic_subnets-2ID of second public subnetprivate_subnets-1ID of first private subnetprivate_subnets-2ID of second private subnetDatabase_subnets-1ID of first database subnetDatabase_subnets-2ID of second database subnetIGWInternet Gateway IDNATNAT Gateway IDEIPElastic IP ID
Network Design
Subnet Layout

Public Subnets: /26 size (62 hosts each)
Private Subnets: /27 size (30 hosts each)
Database Subnets: /27 size (30 hosts each)

Routing

Public subnets route 0.0.0.0/0 through Internet Gateway
Private subnets route 0.0.0.0/0 through NAT Gateway
Database subnets have no internet routing (isolated)

Security Considerations

Credential Management: AWS credentials are stored as variables. Consider using:

AWS IAM roles and instance profiles
AWS Secrets Manager
Environment variables
Terraform Cloud workspaces


Network Isolation:

Database subnets are isolated with no internet access
Private subnets have outbound-only internet access via NAT Gateway
Public subnets are exposed to the internet


Suggested Improvements:

Add Network ACLs for additional security layers
Implement VPC Flow Logs for network monitoring
Consider using VPC Endpoints for AWS service access



Provider Requirements
hclterraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">5.0"
    }
  }
}
License
MIT License
Contributing
Contributions are welcome! Please feel free to submit a Pull Request.
Support
For support, please create an issue in the GitHub repository.
Acknowledgments
This module was created to simplify AWS VPC creation and management using Infrastructure as Code principles.
