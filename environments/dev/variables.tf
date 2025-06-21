variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for dev VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet CIDRs"
}

variable "availability_zones" {
  type        = list(string)
  description = "AZs for subnets"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "instance_name" {
  type        = string
  description = "Name tag for EC2 instance"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
