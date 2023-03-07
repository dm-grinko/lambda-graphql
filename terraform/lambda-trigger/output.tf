output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = join("", aws_lambda_function.lambda.*.arn)
}

output "integration" {
  value = aws_api_gateway_integration.integration
}
