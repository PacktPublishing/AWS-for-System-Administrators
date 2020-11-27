import boto3
from botocore.exceptions import ClientError
import os

ROLE_ARN = os.environ['ROLE_ARN']

ec2 = boto3.client('ec2')
logs = boto3.client('logs')


def lambda_handler(event, context):

    try:
        
        vpcid = event['detail']['responseElements']['vpc']['vpcId']

        cloudwatchloggrp = 'vpcflowcloudwatch' + vpcid

        print('VPC Id: ' + vpcid)

        try:
            response = logs.create_log_group(
                logGroupName=cloudwatchloggrp)
        except ClientError:
            print(f"This Log group '{cloudwatchloggrp}' already exists.")

        
        response = ec2.describe_flow_logs(
            Filter=[
                {
                    'Name': 'resource-id',
                    'Values': [
                        vpcid,
                    ]
                },
            ],
        )

        if len(response['FlowLogs']) > 0:
            print('VPC Flow Logs already ENABLED for this VPC')
        else:
            print('VPC Flow Logs are DISABLED for this VPC')

            response = ec2.create_flow_logs(
                ResourceIds=[vpcid],
                ResourceType='VPC',
                TrafficType='ALL',
                LogGroupName=cloudwatchloggrp,
                DeliverLogsPermissionArn=ROLE_ARN,
            )

            print('Created Flow Logs:' + response['FlowLogIds'][0])

    except Exception as e:
        print('Error - reason "%s"' % str(e))
