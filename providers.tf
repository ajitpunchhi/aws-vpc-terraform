# Add the AWS Provider Information
provider "aws" {
    region = var.aws_region
    secret_key = var.aws_secret-key
    access_key = var.aws_access-key
}