output "ec2_meatweb_01_public_ip" {
  value = module.ec2_meatweb_01.public_ip
}

output "rds_meatweb_01_endpoint" {
  value = module.rds_meatweb_01.endpoint
}

output "lambda_meatweb_01_function_url" {
  value = module.lambda_meatweb_01.function_url
}