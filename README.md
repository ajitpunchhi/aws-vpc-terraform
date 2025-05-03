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

Prerequisites
Before using this Terraform module, ensure you have:

Terraform >= 1.0.0
AWS CLI configured with appropriate credentials
An AWS account with the necessary IAM permissions:
json{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateVpc",
        "ec2:CreateSubnet",
        "ec2:CreateInternetGateway",
        "ec2:CreateNatGateway",
        "ec2:CreateRouteTable",
        "ec2:CreateRoute",
        "ec2:AssociateRouteTable",
        "ec2:AllocateAddress",
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:ModifyVpcAttribute",
        "ec2:CreateTags"
      ],
      "Resource": "*"
    }
  ]
}


Quick Start
1. Clone the Repository
bashgit clone https://github.com/yourusername/aws-vpc-terraform.git
cd aws-vpc-terraform
2. Configure AWS Credentials
Option A: Environment Variables
bashexport AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
export AWS_REGION="ap-south-1"
Option B: Terraform Variables
Create a terraform.tfvars file:
hclaws_access-key = "your_access_key"
aws_secret-key = "your_secret_key"
aws_region     = "ap-south-1"
3. Initialize and Apply
bash# Initialize Terraform
terraform init

# Plan the infrastructure
terraform plan

# Apply the configuration
terraform apply

# Type 'yes' when prompted to confirm
4. Access Outputs
After successful deployment, you can access the resource IDs:
bashterraform output
Configuration
Variables
Variable NameDescriptionDefault Valueaws_regionAWS region for resource creationap-south-1vpc_cidrCIDR block for the VPC20.0.0.0/24public_subnetsList of public subnet CIDR blocks["20.0.0.0/26", "20.0.0.64/26"]private_subnetsList of private subnet CIDR blocks["20.0.0.128/27", "20.0.0.160/27"]Database_subnetsList of database subnet CIDR blocks["20.0.0.192/27", "20.0.0.224/27"]region_azsList of availability zones["ap-south-1a", "ap-south-1b"]
Customization Example
To customize the VPC configuration, create a terraform.tfvars file:
hclvpc_cidr = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
Database_subnets = ["10.0.5.0/24", "10.0.6.0/24"]
region_azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
aws_region = "ap-south-1"
Outputs
The module provides the following outputs:
Output NameDescriptionvpcVPC IDvpc_cidrVPC CIDR blockpublic_subnets-1First public subnet IDpublic_subnets-2Second public subnet IDprivate_subnets-1First private subnet IDprivate_subnets-2Second private subnet IDDatabase_subnets-1First database subnet IDDatabase_subnets-2Second database subnet IDIGWInternet Gateway IDEIPElastic IP IDNATNAT Gateway ID
Network Architecture Details
CIDR Block Allocation
The module uses efficient CIDR block allocation to maximize available IP addresses:

VPC: 20.0.0.0/24 (256 addresses)

Public Subnets: /26 (64 addresses each) - Total: 128 addresses
Private Subnets: /27 (32 addresses each) - Total: 64 addresses
Database Subnets: /27 (32 addresses each) - Total: 64 addresses



Routing Configuration

Public Route Table: Routes to Internet Gateway (0.0.0.0/0)
Private Route Table: Routes to NAT Gateway (0.0.0.0/0)
Database Route Table: Local routing only (no internet access)

Cost Considerations
This module creates the following AWS resources that may incur costs:

VPC (Free)
Subnets (Free)
Internet Gateway (Free)
NAT Gateway (~$0.045/hour + data processing fees)
Elastic IP (~$0.005/hour when not associated)

Total estimated monthly cost: ~$32-40 (primarily NAT Gateway)
Cleanup
To remove all resources created by this module:
bashterraform destroy

# Type 'yes' when prompted to confirm
Troubleshooting
Common Issues

AWS Credentials Error
Error: No valid credential sources found for AWS Provider
Solution: Check AWS credentials configuration or use aws configure
Subnet CIDR Conflicts
Error: The CIDR 'x.x.x.x/x' conflicts with another subnet
Solution: Verify CIDR blocks don't overlap in your configuration
NAT Gateway Creation Timeout
Error: timeout while waiting for state to become 'available'
Solution: This usually occurs with Elastic IP allocation. Wait and retry.

Contributing
Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.
License
This project is licensed under the MIT License - see the LICENSE file for details.
