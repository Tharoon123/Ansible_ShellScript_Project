import boto3
from datetime import datetime, timezone

# Initialize a session using your AWS credentials
s3=boto3.client('s3')


# Define the bucket name and the cutoff date
bucket_name = 'your-bucket-name'
cutoff_date = datetime(2025, 2, 4, tzinfo=timezone.utc)  # Set your cutoff date

#List all Obj
objects = s3.list_objects_v2(Bucket=bucket_name)

# Check if there are any objects in the bucket
if 'Contents' in objects:
    for obj in objects['Contents']:
        # Get the object's last modified date
        last_modified = obj['LastModified']

        # Compare the object's date to the cutoff date
        if last_modified < cutoff_date:
            print(f"Deleting {obj['Key']} (Last Modified: {last_modified})")
            # Delete the object
            s3.delete_object(Bucket=bucket_name, Key=obj['Key'])
else:
    print("No objects found in the bucket.")