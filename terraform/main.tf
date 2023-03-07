terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    # aws s3api create-bucket --bucket poc-apollo-tfstate --region us-east-1 # use this command to create your s3 bucket
    bucket = "poc-apollo-tfstate" // S3 bucket for your terraform state
    key    = "state.tfstate"
    region = "us-east-1"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
