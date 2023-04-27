module "aws_cost_notifier" {
  source             = "../"
  account_name       = "opg-account"
  ecr_repository_url = aws_ecr_repository.cost_notifier.repository_url
  slack_channel_id   = "123456"
  slack_secret_arn   = aws_secretsmanager_secret.aws_notifier_slack_token.arn
  sns_topic_arn      = aws_sns_topic.immediate_cost_anomaly_updates.arn
  version_tag        = "latest"
  providers = {
    aws            = aws
    aws.us-east-1  = aws.us-east-1
    aws.management = aws.management
  }
}