resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/send-cost-anomalies-to-slack-${var.account_name}"
  kms_key_id        = aws_kms_key.cloudwatch.arn
  retention_in_days = 400
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "send-cost-anomalies-to-slack-${var.account_name}"
  image_uri     = "${var.ecr_repository_url}:${var.version_tag}"
  package_type  = "Image"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 60
  depends_on    = [aws_cloudwatch_log_group.lambda]
  environment {
    variables = {
      SLACK_CHANNEL   = var.slack_channel_id
      SLACK_TOKEN_ARN = var.slack_secret_arn
    }
  }
  tracing_config {
    mode = "Active"
  }
}
