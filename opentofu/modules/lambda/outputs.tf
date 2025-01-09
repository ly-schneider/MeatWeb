output "id" {
  description = "The ID of the Lambda function"
  value = aws_lambda_function.lambda_function.id
}

output "function_url" {
  description = "Public URL for the Lambda function"
  value       = aws_lambda_function_url.lambda_function_url.function_url
}