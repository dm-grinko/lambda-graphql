# Lambda GraphQL POC

## Description

This POC demonstrates the use of AWS lambda functions for creating GraphQL API. We have 2 lambda functions. The first one is for the Apollo server (NodeJS) and another one is for a Graphql resolver (Python).

## Usage

1) Create a file ./terraform/variables.tfvars
```
region = "us-east-1"
access_key = "XXXX"
api_gw_name = "XXXX"
secret_key = "XXXX"
stage_name = "dev"
python_lambda_arn = "arn:aws:lambda:us-east-1:XXXX:function:XXXX"
```

2) Create S3 bucket for your terraform state:

`aws s3api create-bucket --bucket <your_bucket_name> --region us-east-1`

3) Update the backend section in `./terraform/main.tf`

4) Install dependencies for the Apollo lambda

```
cd ./lambdas/lambda-apollo
npm i
```

5) Make `./upload.sh` file executable:

`chmod +x ./upload.sh`

6) Check out the ./upload.sh file commands and run it

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
