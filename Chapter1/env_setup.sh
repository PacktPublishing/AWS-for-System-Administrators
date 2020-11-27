#!/usr/bin/env bash

# Script to install AWS Cli, Python SDK Boto3 and Terraform
# This script is verified to run on Ubuntu
if [[ $EUID -ne 0 ]]
then
  echo "This script must be run as root"
  exit 1
fi

# Update/Download package information from all configured sources
apt-get update

# Verify if Python3, curl and jq is installed
which python3 2>/dev/null || { apt-get install -y python3; }
which curl 2>/dev/null || { apt-get install -y curl; }
which jq 2>/dev/null || { apt-get install -y jq; }
which unzip 2>/dev/null || { apt-get install -y unzip; }

# Install pip3
apt-get install -y python3-pip

# installing awscli
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 

unzip awscliv2.zip 

sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin

# Check the aws version
echo "#########################################################################################################################"
echo "Check the AWS Cli Version"
aws --version


# Install Python SDK boto3
pip3 install boto3


# Installing Terraform
function installing-terraform() {
  if which terraform 2>/dev/null
  then
     echo "Terraform is already installed"
  else
  Terraform_12_Ver="$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n -k 5,5n | egrep '0.12' |egrep -v 'rc|beta' | egrep 'linux.*amd64' |tail -1)"
  curl -sL ${Terraform_12_Ver} > /tmp/terraform.zip
  unzip /tmp/terraform.zip
  cp terraform /usr/local/bin
  echo "#########################################################################################################################"
  echo "Terraform Version"
  terraform version
fi
}

installing-terraform
