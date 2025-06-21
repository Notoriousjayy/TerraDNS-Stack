provider "aws" {
  region = var.aws_region
}

# ────────────────────────────────────────────────────────────
# Generate & upload SSH key
# ────────────────────────────────────────────────────────────
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "debian" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh.public_key_openssh
}

# ────────────────────────────────────────────────────────────
# VPC
# ────────────────────────────────────────────────────────────
module "vpc" {
  source             = "../../modules/vpc"
  name               = "dev-vpc"
  cidr_block         = var.vpc_cidr
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
}

# ────────────────────────────────────────────────────────────
# EC2
# ────────────────────────────────────────────────────────────
module "ec2" {
  source            = "../../modules/ec2"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  instance_type     = var.instance_type
  instance_name     = var.instance_name

  # use the key we just uploaded
  key_name = aws_key_pair.debian.key_name

  environment       = var.environment
}

