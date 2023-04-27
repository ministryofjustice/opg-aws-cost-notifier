import boto3
from botocore.config import Config
import os
import json

from slack_sdk import WebClient

def notify(slack_token, slack_channel, message):
    client = WebClient(token=slack_token)
    client.chat_postMessage(
        channel=slack_channel,
        blocks = blocks(message)
    )

def get_token():
    aws_config = Config(
        region_name=os.environ.get('AWS_REGION'),
    )
    secret_manager = boto3.client('secretsmanager', config=aws_config)
    secret_response = secret_manager.get_secret_value(
            SecretId = os.environ.get('SLACK_TOKEN_ARN'),
        )

    return secret_response["SecretString"]

def blocks(message):
    blocks = [
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
                    "text": f"*Account*: `{message.account}` *Region*: `{message.region}`\n\n*Service*: `{message.service}` *Usage Type*: `{message.usageType}`"
                }
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": f"Further details can be found <{message.url}|HERE>"
                }
            }
        ]
    return blocks

class Message:
    def __init__(self, event):
        message = json.loads(event['Records'][0]['Sns']['Message'])
        self.account = message['accountId']
        self.region = message['rootCauses'][0]['region']
        self.url = message['anomalyDetailsLink']
        self.service = message['rootCauses'][0]['service']
        self.usageType = message['rootCauses'][0]['usageType']



def lambda_handler(event, context):
    print(event)
    slack_token = get_token()
    slack_channel = os.environ['SLACK_CHANNEL']
    message = Message(event)
    notify(slack_token, slack_channel, message)
