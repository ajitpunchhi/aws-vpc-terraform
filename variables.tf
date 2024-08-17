# AWS Variables

variable "aws_secret-key" {
    description = "Secret key for authorization"
    type = string
    default = ""
}
variable "aws_access-key" {
    description = "Access Key for authorization"
    type = string
    default = "A"
}

variable "aws_region" {
    description = "Region used to create all resources"
    type = string
    default = "ap-south-1"
}

variable "vpc_cidr" {
    description = "CIDR Raneg used to create vpc"
    type = string
    default = "20.0.0.0/24"
}

variable "public_subnets" {
    description = "Public Subnets for the VPC"
    type = list(string)
    default = [ "20.0.0.0/26","20.0.0.64/26" ]
  
}

variable "private_subnets" {
    description = "Private Subnets for the VPC"
    type = list(string)
    default = [ "20.0.0.128/27","20.0.0.160/27"]  
}

variable "Database_subnets" {
    description = "Databse Subnets for the VPC"
    type = list(string)
    default = [ "20.0.0.192/27","20.0.0.224/27" ]
}

variable "vpc_cidr_staging" {
    description = "CIDR Raneg used to create vpc"
    type = string
    default = "30.0.0.0/24"
}

variable "public_subnets_staging" {
    description = "Public Subnets for the VPC"
    type = list(string)
    default = [ "30.0.0.0/26","30.0.0.64/26" ]
  
}

variable "private_subnets_staging" {
    description = "Private Subnets for the VPC"
    type = list(string)
    default = [ "30.0.0.128/27","30.0.0.160/27"]  
}

variable "Database_subnets_staging" {
    description = "Databse Subnets for the VPC"
    type = list(string)
    default = [ "30.0.0.192/27","30.0.0.224/27" ]
}

variable "region_azs" {
    description = "Availablity Zone"
    type = list(string)
    default = [ "ap-south-1a","ap-south-1b" ] 
}

variable "aws_true" {
    description = "Value should be truew if you want to enable"
    type = bool
    default = true
}

variable "defualt_cidr_block" {
    description = "The valuew of cidr block is 0.0.0.0/0"
    type = string
    default = "0.0.0.0/0"
  
}

variable "https_port" {
    description = "https port"
    type = number
    default = 443
}
variable "http_port" {
    description = "http port"
    type = number
    default = 80
}

variable "ip_protocol" {
    description = "TCP Protocal"
    type = string
    default = "tcp"
  
}

variable "ssh_port" {
    description = "SSH-Port"
    type = number
    default = 22
  
}