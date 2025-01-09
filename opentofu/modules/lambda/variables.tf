variable "role" {
  description = "The ARN of the IAM role that the Lambda function assumes"
  type        = string
}

variable "description" {
  description = "The description of the Lambda function"
  type        = string
}

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "handler" {
  description = "The entry point of the Lambda function"
  type        = string
}

variable "runtime" {
  description = "The runtime of the Lambda function"
  type        = string
}

variable "file_path" {
  description = "The path to the deployment package of the Lambda function"
  type        = string
}

variable "publish" {
  description = "Whether to publish a new version of the Lambda function"
  type        = bool
}

variable "environment_variables" {
  description = "The environment variables that will be passed to the Lambda function"
  type        = map(string)
}

variable "tags" {
  description = "The tags that will be applied to the Lambda function"
  type        = map(string)
}