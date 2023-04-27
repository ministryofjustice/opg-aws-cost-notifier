resource "aws_ecr_repository" "cost_notifier" {
  name     = "shared/aws-cost-notifier"
  provider = aws.management
  image_scanning_configuration {
    scan_on_push = true
  }
}