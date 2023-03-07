# Lambda GraphQL POC

## Description

This POC demonstrates the use of AWS lambda functions for creating GraphQL API

## Usage

- Create a file ./terraform/variables.tfvars

```conf
region = "us-east-1"
access_key = "XXXX"
api_gw_name = "XXXX"
secret_key = "XXXX"
stage_name = "dev"
python_lambda_arn = "arn:aws:lambda:us-east-1:<your_aws_account_id>:function:<your_resolver_lambda_name>"
```

- Create S3 bucket for your terraform state:

`aws s3api create-bucket --bucket <your_bucket_name> --region us-east-1`

- Update the backend section in `./terraform/main.tf`

- Install dependencies for the Apollo lambda

```bash
cd ./lambdas/lambda-apollo
npm i
```

- Make `./upload.sh` file executable:

`chmod +x ./upload.sh`

- Check out the ./upload.sh file commands and run it

`./upload.sh`

## TEST

`https://XXXXXXXXXX.execute-api.us-east-1.amazonaws.com/dev/graphql`

```graphql
query book {
  book(author: "Paul Auster") {
    author
    title
  }
}

query book {
  book(title: "The Awakening") {
    author
    title
  }
}

query books {
  books {
    author
    title
  }
}
```
