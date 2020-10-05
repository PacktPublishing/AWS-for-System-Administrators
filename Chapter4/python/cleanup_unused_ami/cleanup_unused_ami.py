import boto3
import datetime
from dateutil.parser import parse 
AMI_AGE = 7

def date_diff(date):
	parse_date = parse(date).replace(tzinfo=None)
	diff = datetime.datetime.now() - parse_date
	return diff.days


def lambda_handler(event, context):
    ec2client = boto3.client('ec2')
    
    for region in ec2client.describe_regions()['Regions']:
        regions = (region['RegionName'])
        ec2 = boto3.client('ec2', region_name = regions)
        print("Regionname:", regions)
        amis = ec2.describe_images(Owners=['self'])['Images']
        
        for ami in amis:
            ami_creation_date = ami['CreationDate']
            ami_age_diff = date_diff(ami_creation_date)
            ami_image_id = ami['ImageId']
            
            
            if ami_age_diff > AMI_AGE:
                print("Deleting all the ami greater then 7 days old", ami_image_id)
                ec2.deregister_image(ImageId=ami_image_id)
