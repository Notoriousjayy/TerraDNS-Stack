variable "vpc_id" {
  description = "VPC ID to launch instance into"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Existing AWS key pair name"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "ami_owner" {
  description = "AWS account ID that publishes the Debian Cloud AMIs"
  type        = string
  default     = "136693071363"
}

variable "ami_name_pattern" {
  description = "Wildcard pattern for the Debian AMI name"
  type        = string
  default     = "debian-11-amd64-*"
}

variable "ssh_ingress_cidr" {
  description = "CIDR block allowed to SSH in"
  type        = string
  default     = "0.0.0.0/0"
}
