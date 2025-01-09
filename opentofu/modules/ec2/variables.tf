variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the instance"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to use for the instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "The security group IDs to use for the instance"
  type        = list(string)
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
}

variable "key_name" {
  description = "The key pair name to use for the instance"
  type        = string
}

variable "tags" {
  description = "The tags for the key pair"
  type        = map(string)
}