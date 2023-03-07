module "apollo_lambda" {
  source        = "./lambda-trigger"
  runtime       = "nodejs16.x"
  source_dir    = "../lambdas/lambda-apollo/build/src"
  handler       = "index.handler"
  output_path   = "../lambdas/lambda-apollo.zip"
  function_name = "${var.api_gw_name}_Lambda_Apollo"
  role_name     = "${var.api_gw_name}_Lambda_Apollo_Role"
  role          = "./iam/lambda_role.json"
  policy_name   = "${var.api_gw_name}_Lambda_Apollo_Role_Policy"
  policy        = "./iam/lambda_invoke_policy.json"
  path_part   = "graphql"
  http_method = "POST"
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  request_template = "./request_template.template"
  python_lambda_arn = var.python_lambda_arn
}

module "python_lambda" {
  source        = "./lambda"
  runtime       = "python3.8"
  source_dir    = "../lambdas/lambda-python"
  handler       = "index.handler"
  output_path   = "../lambdas/lambda-python.zip"
  function_name = "${var.api_gw_name}_Lambda_Python"
  role_name     = "${var.api_gw_name}_Lambda_Python_Role"
  role          = "./iam/lambda_role.json"
  policy_name   = "${var.api_gw_name}_Lambda_Python_Role_Policy"
  policy        = "./iam/lambda_policy.json"
}