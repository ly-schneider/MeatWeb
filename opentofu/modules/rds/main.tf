resource "aws_db_instance" "this" {
  engine                       = var.engine
  engine_version               = var.engine_version
  instance_class               = var.instance_class
  identifier                   = var.identifier
  username                     = var.username
  password                     = var.password
  port                         = var.port
  publicly_accessible          = var.publicly_accessible
  db_subnet_group_name         = var.db_subnet_group_name
  vpc_security_group_ids       = var.vpc_security_group_ids

  parameter_group_name = var.parameter_group_name
  option_group_name    = var.option_group_name

  storage_encrypted     = var.storage_encrypted
  storage_type          = var.storage_type
  deletion_protection   = var.deletion_protection
  allocated_storage     = var.allocated_storage

  multi_az = var.multi_az

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

  backup_window                  = var.backup_window
  maintenance_window             = var.maintenance_window
  auto_minor_version_upgrade     = var.auto_minor_version_upgrade
  skip_final_snapshot            = var.skip_final_snapshot
  apply_immediately              = var.apply_immediately

  tags                  = var.tags
}