variable "identifier" {
  description = "The identifier for the RDS instance."
  type        = string
}

variable "instance_class" {
  description = "The instance class for the RDS instance."
  type        = string
}

variable "engine" {
  description = "The database engine to use for the RDS instance."
  type        = string
}

variable "engine_version" {
  description = "The version of the database engine."
  type        = string
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
}

variable "username" {
  description = "The username for the master DB user."
  type        = string
}

variable "password" {
  description = "The password for the master DB user."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of VPC security group IDs to associate with the RDS instance."
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Whether the RDS instance should be publicly accessible."
  type        = bool
}

variable "db_subnet_group_name" {
  description = "The name of the DB subnet group."
  type        = string
}

variable "port" {
  description = "The port on which the RDS instance accepts connections."
  type        = number
}

variable "parameter_group_name" {
  description = "The name of the parameter group to associate with the RDS instance."
  type        = string
}

variable "option_group_name" {
  description = "The name of the option group to associate with the RDS instance."
  type        = string
}

variable "storage_encrypted" {
  description = "Whether the RDS instance should have storage encryption enabled."
  type        = bool
}

variable "storage_type" {
  description = "The type of storage to use for the RDS instance."
  type        = string
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled for the RDS instance."
  type        = bool
}

variable "allocated_storage" {
  description = "The amount of storage to allocate for the RDS instance."
  type        = number
}

variable "multi_az" {
  description = "Whether the RDS instance should be multi-AZ."
  type        = bool
}

variable "performance_insights_enabled" {
  description = "Whether Performance Insights should be enabled for the RDS instance."
  type        = bool
}

variable "performance_insights_retention_period" {
  description = "The number of days to retain Performance Insights data."
  type        = number
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created."
  type        = string
}

variable "maintenance_window" {
  description = "The weekly time range during which system maintenance can occur."
  type        = string
}

variable "auto_minor_version_upgrade" {
  description = "Whether minor version upgrades are applied automatically to the RDS instance."
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Whether a final DB snapshot is created before the RDS instance is deleted."
  type        = bool
}

variable "apply_immediately" {
  description = "Whether changes to the RDS instance should be applied immediately."
  type        = bool
}

variable "tags" {
  description = "A map of tags to apply to the RDS instance."
  type        = map(string)
}