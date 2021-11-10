# Fetching dynamic ddata
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name   = var.env
  region = var.AWS_REGION
  tags = {
    Environment = var.env
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.11.0"

  name = local.name
  cidr = var.vpc_cidr

  azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets   = var.public_subnet
  private_subnets  = var.private_subnet
  database_subnets = var.database_subnet
  enable_nat_gateway = true
  single_nat_gateway = true
  create_database_subnet_group = true

  tags = local.tags
}

resource "aws_security_group" "default_instances" {
  name        = "default instances"
  description = "Default rules for instances"
  vpc_id      = module.vpc.vpc_id
  tags        = local.tags
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 0
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.default_instances.id
}
resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.default_instances.id
}

