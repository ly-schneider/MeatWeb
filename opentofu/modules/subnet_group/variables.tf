variable "name" {
  description = "The name of the DB subnet group."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs to use for the RDS instance."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to apply to the RDS instance."
  type        = map(string)
}