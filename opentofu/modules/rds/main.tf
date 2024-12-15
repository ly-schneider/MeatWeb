resource "aws_db_subnet_group" "this" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier           = var.identifier
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  db_name                 = var.db_name
  username             = var.username
  password             = var.password
  db_subnet_group_name = aws_db_subnet_group.this.name
  publicly_accessible  = var.publicly_accessible
  vpc_security_group_ids = var.vpc_security_group_ids
  port                 = var.port
  skip_final_snapshot = true # Dev/Test environment
  deletion_protection = false # Dev/Test environment

  tags = var.tags
}
