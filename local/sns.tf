resource "aws_sns_topic" "immediate_cost_anomaly_updates" {
  name     = "immediateCostAnomalyUpdates"
  provider = aws.us-east-1
}