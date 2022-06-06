from boto3.session import Session
from pathlib import PurePosixPath

ACCESS_KEY=''
SECRET_KEY=''
bucket_name = ''
pattern= '[0-9]:*.db'

session = Session(aws_access_key_id=ACCESS_KEY, aws_secret_access_key=SECRET_KEY)
s3 = session.resource('s3')
bucket = s3.Bucket(bucket_name)

content="String content to write to a new S3 file"
s3.Object(bucket_name , 'file.db').put(Body=content)

for s3_file in bucket.objects.all():
    s3_filepath = s3_file.key
    if PurePosixPath(s3_filepath).match(pattern):
        print(f'delete file: {s3_filepath}')
        s3.Object(bucket_name , s3_filepath).delete()


