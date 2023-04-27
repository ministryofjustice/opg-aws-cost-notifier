from send_cost_anomalies_to_slack import Message, blocks
import pytest

@pytest.fixture
def event():
    return {
        "Records": [
            {
                "EventSource": "aws:sns",
                "EventVersion": "1.0",
                "EventSubscriptionArn": "arn:aws:sns:us-east-1: 1234567890:immediateCostAnomalyUpdates: 206d27da-9f09-44f3-8d9f-3164b59219ab",
                "Sns": {
                    "Type": "Notification",
                    "MessageId": "2cdcea49-c94c-5ad6-85e7-b6e6afb934bf",
                    "TopicArn": "arn:aws:sns:us-east-1: 1234567890:immediateCostAnomalyUpdates",
                    "Subject": "None",
                    "Message": '{"accountId":"1234567890","accountName":"opg-account","anomalyStartDate":"2023-04-05T00:00:00Z","anomalyEndDate":"2023-04-10T00:00:00Z","anomalyId":"6de0dd1d-feb4-488a-a55d-ff130a7a285a","dimensionalValue":"AWS CloudTrail","monitorArn":"arn:aws:ce::1234567890:anomalymonitor/bdafded2-49c6-407e-885a-e29618f58b2a","monitorName":"AWSServiceMonitor","monitorType":"DIMENSIONAL","anomalyScore":{"maxScore":0.67,"currentScore":0.51},"impact":{"maxImpact":2.48,"totalExpectedSpend":0.27,"totalActualSpend":12.09,"totalImpact":11.82,"totalImpactPercentage":4377.78},"rootCauses":[{"service":"AWS CloudTrail","region":"eu-west-1","linkedAccount":"1234567890","linkedAccountName":"opg-account","usageType":"EU-InsightsEvents"}],"anomalyDetailsLink":"https://console.aws.amazon.com/cost-management/home#/anomaly-detection/monitors/","subscriptionId":"458ba0da-929a-4de9-b38b-7a2381a32561","subscriptionName":"Immediate Subscription"}',
                    "Timestamp": "2023-04-11T13: 46: 29.757Z",
                    "SignatureVersion": "1",
                    "Signature": "TMiSRkbJN4jrHCFgtVuHZi7ISgRU+3eFGwIIK3vTrh2ktL4AL7djvB1TqTlfH2XKS1Yosobgl8ystLhoSgkYYl3iM9cEYakpHc+xNFgevaLpBAv1KJk+/qk7f9yU6DoiwSNsV2f8CpZPG/7uYqAy59lfEL5KuN0JMGuJc6Pbn9wQRzsFXRHwkJqaA4TZ421eCi/EVaRm7lYiyYlrFZinbINWwkQvCq5reiBmkyjwhH4xwSdawZuc3G9L8Ah3BHuvqp5priqw2r8KtAai27CtG+NwyS6XmF/JSLYroxcwZXjd1VmvJk09IDV97DywXPl5iXWwlk3U58t/OuKHLpHwJw==",
                    "SigningCertUrl": "https: //sns.us-east-1.amazonaws.com/SimpleNotificationService-5.pem",
                    "UnsubscribeUrl": "https://sns.us-east-1.amazonaws.com/",
                    "MessageAttributes": {}
                }
            }
        ]
}

def test_message_class_base(event):
    message = Message(event)

    assert message.account == "1234567890"
    assert message.region == "eu-west-1"
    assert message.url == "https://console.aws.amazon.com/cost-management/home#/anomaly-detection/monitors/"
    assert message.service == "AWS CloudTrail"
    assert message.usageType == "EU-InsightsEvents"

def test_block(event):
    message = Message(event)
    response = blocks(message)
    expected_response = [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": ":alert: A cost anomaly has been detected. :alert:"
                }
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"*Account*: `1234567890` *Region*: `eu-west-1`\n\n*Service*: `AWS CloudTrail` *Usage Type*: `EU-InsightsEvents`"
                }
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"Further details can be found <https://console.aws.amazon.com/cost-management/home#/anomaly-detection/monitors/|HERE>"
                }
            }
        ]
    assert response == expected_response
