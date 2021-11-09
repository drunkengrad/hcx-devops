output "rds_endpoint" {
  description = "RDS cluster endpoint"
  value = aws_db_instance.rds.address
}
