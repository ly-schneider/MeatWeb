variable "key_name" {
  description = "The name of the key pair"
  type        = string
}

variable "public_key_path" {
  description = "The public key path"
  type        = string
}

variable "tags" {
  description = "The tags for the key pair"
  type        = map(string)
}