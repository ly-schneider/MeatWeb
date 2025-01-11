variable "name" {
  description = "The name of the DB subnet group."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs to use in the DB subnet group."
  type        = list(string)
}

variable "tags" {
  description = "Tags to associate with the DB subnet group."
  type        = map(string)
}