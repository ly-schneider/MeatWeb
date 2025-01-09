variable "vpc_id" {
  description = "The VPC ID to create the internet gateway in."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to the internet gateway."
  type        = map(string)
}