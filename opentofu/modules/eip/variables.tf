variable "instance" {
  description = "The ID of the instance to associate with the EIP."
  type        = string
}

variable "domain" {
  description = "Set to vpc to have the EIP in a VPC."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}