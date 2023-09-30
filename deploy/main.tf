terraform {
  backend "s3" {
    bucket         = "website-prod-devops-tfstate"
    key            = "devops.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "website-production-tf-state-lock"
  }
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.54.0"
}

locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}

data "aws_region" "current" {}
