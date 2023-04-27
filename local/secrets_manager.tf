resource "aws_secretsmanager_secret" "aws_notifier_slack_token" {
  name = "aws-notifier-slack-bot-token"
}

resource "aws_secretsmanager_secret_version" "aws_notifier_slack_token" {
  secret_id     = aws_secretsmanager_secret.aws_notifier_slack_token.id
  secret_string = "thisisateststring"
}
