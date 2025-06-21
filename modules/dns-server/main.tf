# 1) DNS SG
resource "aws_security_group" "dns" {
  name        = "${var.instance_name}-dns-sg"
  description = "Allow DNS queries & zone transfers"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # SSH if you still want console access
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
    Name = "${var.instance_name}-dns-sg"
  }
}

# 2) Elastic IP
resource "aws_eip" "this" {
  instance = module.vm.instance_id
}

# 3) Render your named.conf into a user_data script
data "template_file" "bind" {
  template = file("${path.module}/templates/named.conf.${var.role}.tpl")
  vars = {
    zone_name = var.zone_name
    master_ip = var.master_ip
  }
}

# 4) Use the reusable EC2 module
module "vm" {
  source            = "../ec2"
  vpc_id            = var.vpc_id
  public_subnet_ids = var.public_subnet_ids
  instance_type     = var.instance_type
  key_name          = var.key_name

  # DNS-specific extras
  extra_security_group_ids = [ aws_security_group.dns.id ]
  user_data                = base64encode(data.template_file.bind.rendered)
  associate_public_ip      = false    # since you attach EIP explicitly

  environment = var.environment
  instance_name = var.instance_name
  tags = {
    Role = var.role
  }
}
