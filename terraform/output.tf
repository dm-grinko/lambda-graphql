output "apollo_lambda_invoke_url" {
  description = "The URL to invoke the API pointing to the stage, e.g."
  value       = aws_api_gateway_stage.stage.invoke_url
}

output "apollo_lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.apollo_lambda.function_arn
}

output "resolver_lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.resolver_lambda.function_arn
}