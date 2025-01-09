data "aws_iam_role" "lambda_execution_role" {
  name = var.role
}

resource "aws_lambda_function" "lambda_function" {
  description   = var.description
  function_name = var.function_name
  role          = data.aws_iam_role.lambda_execution_role.arn
  handler       = var.handler
  runtime       = var.runtime

  filename         = var.file_path
  source_code_hash = filebase64sha256(var.file_path)

  publish       = var.publish

  environment {
    variables = var.environment_variables
  }

  tags = var.tags
}

resource "aws_lambda_function_url" "lambda_function_url" {
  function_name      = aws_lambda_function.lambda_function.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_headers     = ["Content-Type"]
    allow_methods     = ["GET", "POST"]
    allow_origins     = ["*"]
    expose_headers    = []
    max_age           = 0
  }
}