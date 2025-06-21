##############################
# Data Source: Latest Debian AMI
##############################
data "aws_ami" "debian" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

##############################
# Resource: Security Group for SSH
##############################
resource "aws_security_group" "ssh" {
  name        = "${var.instance_name}-ssh"
  description = "Allow SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ingress_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name}-sg"
  }
}

##############################
# Resource: EC2 Instance
##############################
resource "aws_instance" "this" {
  ami                         = data.aws_ami.debian.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  subnet_id                   = var.public_subnet_ids[0]
  associate_public_ip_address = true

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}