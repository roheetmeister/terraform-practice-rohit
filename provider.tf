# Declare name of provider..!!
provider "aws" {
  region = var.region

}

# Keeping tfstate remotely as backen service AWS S3

terraform {
  backend "s3" {
    bucket         = "terraform-bucket-new"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "dynamodb_table"
  }
}
