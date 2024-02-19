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

resource "aws_cloudwatch_metric_alarm" "failed_invocation" {
  actions_enabled   = var.failed_invocation_sns_arn != "" ? true : false
  alarm_actions     = [var.failed_invocation_sns_arn]
  alarm_description = "Cost Notifier Lambda Errors"
  alarm_name        = "cost-notifier-lambda-errors"
  depends_on = [
    aws_lambda_function.lambda_function
  ]

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Average"
  threshold           = 0

  dimensions = {
    FunctionName = aws_lambda_function.lambda_function.function_name
  }
}
