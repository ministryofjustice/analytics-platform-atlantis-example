terraform {
  backend "s3" {
    bucket               = "mojap-atlantis-terraform-test"
    workspace_key_prefix = "example:"
    key                  = "terraform.tfstate"
    region               = "eu-west-1"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "~> 1.50"
}

module "s3" {
  source = "modules/s3_bucket"

  env = "${var.env}"
  bucket_name = "${var.bucket_name}"
}

module "lambda_function" {
  source          = "modules/lambda_function"

  env = "${var.env}"
  sensitive_value = "${var.lambda_sensitive_value}"
}
