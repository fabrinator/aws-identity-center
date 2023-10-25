terraform {
  backend "s3" {
    bucket = "tfstate-frivas-crc"
    key    = "aws/aws-identity-center"
    region = "us-east-1"
    dynamodb_table = "app-state"
  }
}

