This Terraform project creates an AWS Virtual Private Cloud (VPC). This README guides you through setting up the VPC infrastructure with Terraform, including the prerequisites, usage instructions, and how to customize the VPC configuration.

# AWS VPC Terraform Module

This Terraform module creates an Amazon Web Services (AWS) Virtual Private Cloud (VPC) along with subnets, route tables, and gateways. It provides an easy-to-use interface to set up a basic network infrastructure in AWS.

## Features

- Create a VPC with configurable CIDR block
- Create public and private subnets across multiple Availability Zones
- Configure route tables for the subnets
- Create an Internet Gateway (IGW) and associate it with the public route table
- Create a NAT Gateway for private subnet outbound internet access
- Optionally enable VPC Flow Logs

## Prerequisites

Before using this Terraform module, ensure that you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0.0
- AWS CLI configured with appropriate credentials
- An AWS account with the necessary permissions to create VPC resources

## Usage

### Clone the repository

```bash
git clone https://github.com/yourusername/aws-vpc-terraform.git
cd aws-vpc-terraform

### Configure Terraform Variables

### Initialize Terraform
Initialize the Terraform working directory. This command downloads the provider and module dependencies.

bash
Copy code
terraform init
