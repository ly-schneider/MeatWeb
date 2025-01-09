variable "aws_region" {
  description = "AWS region for the deployment"
  default     = "us-east-1"
}

variable "DISCORD_PUBLIC_KEY" {
  type      = string
  sensitive = true
}

variable "DB_HOST" {
  type      = string
  sensitive = true
}

variable "DB_PORT" {
  type      = string
  sensitive = true
}

variable "DB_USER" {
  type      = string
  sensitive = true
}

variable "DB_PASSWORD" {
  type      = string
  sensitive = true
}

variable "DB_NAME" {
  type      = string
  sensitive = true
}
