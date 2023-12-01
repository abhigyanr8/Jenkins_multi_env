terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  # Remote S3 backend to store the TF state file [*.tfstate]
  backend "s3" {
    key = "core-sizing-aws-infra/terraform.tfstate"
  }
}

# provider block
provider "aws" {
  region = var.AWS_REGION
  # profile = var.AWS_PROFILE
}
