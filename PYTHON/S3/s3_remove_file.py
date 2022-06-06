from boto3.session import Session
from pathlib import PurePosixPath

ACCESS_KEY='your_aws_access_key'
SECRET_KEY='your_aws_secret_key'
bucket_name = 'your_bucket_name'
pattern= 'your_pattern_string____db_[a-z][asdfdgsfdmuv]mps/*/[as]qlite/[0-9]*.db3'

session = Session(aws_access_key_id=ACCESS_KEY, aws_secret_access_key=SECRET_KEY)
s3 = session.resource('s3')
bucket = s3.Bucket(bucket_name)

for s3_file in bucket.objects.all():
    s3_filepath = s3_file.key
    if PurePosixPath(s3_filepath).match(pattern):
        s3.Object(bucket_name , s3_filepath).delete()
        print(f'deleted file: {s3_filepath}')


# ###output result
# deleted file: db_dumps/khoma/sqlite/2021-11-30-08:03:04.db3
