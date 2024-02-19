variable "account_name" {
  type        = string
  description = "AWS account name"
}

variable "ecr_repository_url" {
  type        = string
  description = "URL of the ECR repository"
}

variable "failed_invocation_sns_arn" {
  type        = string
  default     = ""
  description = "ARN of SNS Topic to send failed invocations to."
}

variable "slack_channel_id" {
  type        = string
  description = "Slack's internal ID for the channel you want to post messages, format AB1C2DEF"
}

variable "slack_secret_arn" {
  type        = string
  description = "ARN of the AWS secrets manager secret containing the slack app token"
}

variable "sns_topic_arn" {
  type        = string
  description = "ARN of the cost anomaly alert immediate subscription SNS topic"
}

variable "version_tag" {
  type        = string
  default     = "latest"
  description = "Tag of the AWS Cost Notifier Image to Deploy"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
