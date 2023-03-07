resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_gw_name
  description = "API Gateway"
}

resource "aws_api_gateway_account" "account" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch_global_role.arn
}

resource "aws_iam_role" "cloudwatch_global_role" {
  name = "api_gateway_cloudwatch_global"
  assume_role_policy = file("./iam/cloudwatch_role.json")
}

// For Opt #2
resource "aws_iam_policy" "api_gateway_logging" {
  name        = "${var.api_gw_name}-api-gateway-logging"
  path        = "/"
  description = "IAM policy for logging from the api gateway"
  policy = file("./iam/cloudwatch_policy.json")
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.cloudwatch_global_role.name
  # policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs" // Opt #1
  policy_arn = aws_iam_policy.api_gateway_logging.arn // Opt #2
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    module.apollo_lambda.integration,
    module.python_lambda.integration
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_stage" "stage" {
  depends_on    = [aws_api_gateway_deployment.deployment]
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
}

resource "aws_api_gateway_method_settings" "settings" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    data_trace_enabled = true
    metrics_enabled = true
    logging_level   = "ERROR"
  }
}

resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "/aws/lambda/${var.api_gw_name}-api-gateway"
  retention_in_days = 14
}