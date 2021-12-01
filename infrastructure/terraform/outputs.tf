output "rds_endpoint" {
  description = "RDS cluster endpoint"
  value = aws_db_instance.rds.address
}
output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
