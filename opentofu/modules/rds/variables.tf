variable "identifier" {
  description = "The identifier for the RDS instance."
  type        = string
}

variable "instance_class" {
  description = "The instance class for the RDS instance."
  type        = string
}

variable "allocated_storage" {
  description = "The amount of storage allocated to the RDS instance in GiB."
  type        = number
}

variable "storage_type" {
  description = "The storage type for the RDS instance."
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

variable "subnet_ids" {
  description = "List of subnet IDs for the DB Subnet Group."
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Whether the RDS instance should be publicly accessible."
  type        = bool
}

variable "db_subnet_group_name" {
  description = "The name of the DB subnet group."
  type        = string
  default     = "rds-subnet-group"
}

variable "tags" {
  description = "Tags to associate with the RDS instance."
  type        = map(string)
}

variable "port" {
  description = "The port on which the RDS instance accepts connections."
  type        = number
}