resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = var.sns_topic_arn
  endpoint  = aws_lambda_function.lambda_function.arn
  protocol  = "lambda"
  provider  = aws.us-east-1
}
