variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "cidr_block" {
  description = "CIDR block"
  type = string
}

variable "gateway_id" {
  description = "Gateway ID"
  type = string
}

variable "tags" {
  description = "Tags"
  type = map(string)
}