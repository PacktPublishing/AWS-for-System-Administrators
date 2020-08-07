import boto3

def lambda_handler(event, context):
	ec2client = boto3.client('ec2')

	for region in ec2client.describe_regions()['Regions']:
		regions = (region['RegionName'])
		ec2 = boto3.resource('ec2', region_name = regions)
		print("Regionname:", regions)


		running_instances = ec2.instances.filter(Filters=[{'Name': 'instance-state-name','Values': ['running']}])

		for instance in running_instances:
			print("Stopping instance: ", instance.id)
			instance.stop()
