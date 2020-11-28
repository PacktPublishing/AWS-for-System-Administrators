#!/bin/bash
aws iam create-role --role-name VPCFlowLogsRole --assume-role-policy-document file://trustpolicy.json
aws iam put-role-policy --role-name VPCFlowLogsRole --policy-name VPCFlowLogsPolicy --policy-document file://vpcflowlog.json
aws iam create-role --role-name VPCFlowLogsEnableRole --assume-role-policy-document file://lambdatrustpolicy.json
aws iam put-role-policy --role-name VPCFlowLogsEnableRole --policy-name vpcflowlogenablepolicy --policy-document file://vpcflowlogsenable.json
