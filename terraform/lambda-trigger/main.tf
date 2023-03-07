data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = var.output_path
}

resource "aws_iam_role" "lambda_role" {
  name               = var.role_name
  assume_role_policy = file(var.role)
}

resource "aws_iam_policy" "lambda_policy" {
  name        = var.policy_name
  path        = "/"
  description = "AWS IAM Policy"
  policy      = file(var.policy)
}

resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  filename      = var.output_path
  role          = aws_iam_role.lambda_role.arn
  handler       = var.handler
  runtime       = var.runtime
  environment {
    variables = {
      RESOLVER_LAMBDA_ARN = var.resolver_lambda_arn
    }
  }
  depends_on    = [aws_iam_role_policy_attachment.attachment]
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = var.http_method
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "integration" {
  depends_on  = [aws_lambda_function.lambda]
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  # type                    = "AWS"
  uri                     = aws_lambda_function.lambda.invoke_arn

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }

  # request_templates = {
  #   "application/json" = file("./template.json")
  # }
}

resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowExecutionFromAPIGW"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
}
