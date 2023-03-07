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
    name         = var.policy_name
    path         = "/"
    description  = "AWS IAM Policy"
    policy       = file(var.policy)
}

resource "aws_lambda_function" "lambda" {
    function_name  = var.function_name
    filename       = var.output_path
    role           = aws_iam_role.lambda_role.arn
    handler        = var.handler
    runtime        = var.runtime
    depends_on     = [aws_iam_role_policy_attachment.attachment]
}

resource "aws_iam_role_policy_attachment" "attachment" {
    role        = aws_iam_role.lambda_role.name
    policy_arn  = aws_iam_policy.lambda_policy.arn
}
