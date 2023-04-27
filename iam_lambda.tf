resource "aws_iam_role" "lambda_role" {
  name               = "cost-anomaly-lambda-${var.account_name}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "lambda" {
  name   = "cost-anomaly-lambda-policy-${var.account_name}"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda.json
}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid       = "allowLogging"
    effect    = "Allow"
    resources = [aws_cloudwatch_log_group.lambda.arn]
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
  }

  statement {
    sid       = "secretManager"
    effect    = "Allow"
    resources = [var.slack_secret_arn]
    actions = [
      "secretsmanager:GetSecretValue",
    ]
  }

  statement {
    sid       = "lambda"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "lambda:ListFunctions"
    ]
  }

  statement {
    sid       = "xray"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords"
    ]
  }

  statement {
    sid       = "invokeLambda"
    effect    = "Allow"
    resources = ["arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:function:send-cost-anomalies-to-slack-*"]
    actions = [
      "lambda:InvokeFunction"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "vpc_access_execution_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_permission" "allow_lambda_execution_sns" {
  statement_id  = "AllowSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}
