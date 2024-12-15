output "vpc_id" {
  value = module.vpc_meatweb_01.id
}

# output "subnet_ids" {
#   value = [module.subnet_meatweb_01.id, module.subnet_meatweb_02.id, module.subnet_meatweb_03.id]
# }

output "security_group_ids" {
  value = [module.sg_ec2_meatweb_01.id, module.sg_rds_meatweb_01.id, module.sg_lambda_meatweb_01.id]
}

# output "rds_endpoint" {
#   description = "The endpoint of the RDS instance."
#   value       = module.rds_meatweb_01.endpoint
# }