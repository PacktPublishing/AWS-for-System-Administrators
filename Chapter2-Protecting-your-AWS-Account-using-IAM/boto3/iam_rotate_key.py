import boto3
from datetime import datetime, timezone
KEY_MAXIMUM_AGE = 60

iam = boto3.client("iam")
iam_all_users = iam.list_users()


def key_age(access_key_creation_date):
	current_date = datetime.now(timezone.utc)
	age = current_date - access_key_creation_date
	return age.days

for user in iam_all_users['Users']:
	iam_user = user['UserName']
	response = iam.list_access_keys(UserName=iam_user)
	

	for access_key in response['AccessKeyMetadata']:
		access_keyid = access_key['AccessKeyId']
		access_key_creation_date = access_key['CreateDate']
		print(f'IAM UserName: {iam_user} {access_keyid} {access_key_creation_date}')
		age = key_age(access_key_creation_date)

		if age < KEY_MAXIMUM_AGE:
			continue
		
		print(f'Deactivating the key for a particular user {iam_user} as it exceed the maximum key age')
		iam.update_access_key(UserName=iam_user,AccessKeyId=access_keyid,Status='Inactive')
