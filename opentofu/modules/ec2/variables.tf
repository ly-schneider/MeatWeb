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

variable "volume_size" {
  description = "The size of the root volume in gibibytes"
  type        = number
}

variable "volume_type" {
  description = "The type of the root volume"
  type        = string
}

variable "delete_on_termination" {
  description = "Whether to delete the root volume when the instance is terminated"
  type        = bool
}

variable "tags" {
  type        = map(string)
}