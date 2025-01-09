variable "aws_region" {
  description = "AWS region for the deployment"
  default     = "us-east-1"
}

variable "discord_public_key" {
  type      = string
  sensitive = true
}
