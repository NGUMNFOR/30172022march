provider "aws" {
    region = "us-west-2"

    assume_role {
      role_arn = "arn:aws:iam::877759812082:role/Testrole"
    }
}
terraform {
  backend "s3" {
    bucket = "ilsstatebucket"
    key    = "path/to/statebucket"
    region = "us-west-2"
    dynamodb_table  = "ilsstatetable"
  }
}
#myterra01bucket