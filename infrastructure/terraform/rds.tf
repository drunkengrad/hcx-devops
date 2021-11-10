resource "aws_security_group" "allow_postgres" {
  name        = "allow_postgres"
  description = "Allow postgres inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress = [
    {
      description      = "Postgresql from VPC"
      from_port        = 0
      to_port          = 5432
      protocol         = "tcp"
      cidr_blocks      = [module.vpc.vpc_cidr_block]
      ipv6_cidr_blocks = []
      # Bug
      # Refer: https://github.com/hashicorp/terraform-provider-aws/issues/21573
      prefix_list_ids = null
      security_groups = null
      self            = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Postgresql outbound"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    Name = "allow_postgres"
  }
}

resource "aws_db_instance" "rds" {
  engine                = "postgres"
  engine_version        = "11.10"
  instance_class        = "db.t3.large"
  allocated_storage     = 20
  max_allocated_storage = 100
  db_subnet_group_name  = module.vpc.database_subnet_group
  skip_final_snapshot   = true
  name                  = "postgresql"
  username              = "hcxpostgresql"
  password              = var.postgres_password
  port                  = 5432
  tags = local.tags
  vpc_security_group_ids = [aws_security_group.allow_postgres.id]
}
