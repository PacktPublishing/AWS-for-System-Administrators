import boto3

def lambda_handler(event, context):
    ec2client = boto3.client('ec2')
    for region in ec2client.describe_regions()['Regions']:
        regions = (region['RegionName'])
        ec2 = boto3.resource('ec2', region_name = regions)
        print("Regionname:", regions)
        
        unattached_ebs_vol = ec2.volumes.filter(Filters=[{'Name':'status','Values': ['available']}])
        
        for vol in unattached_ebs_vol:
            v = ec2.Volume(vol.id)
            print("Cleaning up all the unattached ebs Volumes")
            v.delete()
