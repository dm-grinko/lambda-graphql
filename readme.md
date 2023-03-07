# Lambda GraphQL POC

## Usage

1) Create a file ./terraform/variables.tfvars
```
region = "us-east-1"
access_key = "XXXX"
api_gw_name = "XXXX"
secret_key = "XXXX"
stage_name = "dev"
```

2) Create S3 bucket for your terraform state:

`aws s3api create-bucket --bucket <your_bucket_name> --region us-east-1`

3) Update the backend section in `./terraform/main.tf`

4) Make `./upload.sh` file executable:

`chmod +x ./upload.sh`

5) Check out the ./upload.sh file commands and run it

`./upload.sh`
