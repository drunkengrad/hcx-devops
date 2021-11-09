resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "db-subnet-group"
  # subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.public_subnet.id]
  subnet_ids = aws_subnet.private_subnet[*].id
  tags = {
    Name        = "rds"
    Environment = var.env
  }
}

resource "aws_db_instance" "rds" {
  engine                = "postgres"
  engine_version        = "11.10"
  instance_class        = "db.t3.large"
  allocated_storage     = 20
  max_allocated_storage = 100
  db_subnet_group_name  = aws_db_subnet_group.db-subnet-group.name
  skip_final_snapshot   = true
  name                  = "postgresql"
  username              = "{{username}}"
  password              = "{{passowrd}}"
  port                  = 5432
}
