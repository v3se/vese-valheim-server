terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.69.0"
    }
  }
  required_version = ">=1.0.0"
  backend "s3" {
    bucket = "iiharanrlhyclpbcizqw"
    key    = "terraform/valheim-server.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      project = var.project_common_tag
    }
  }
}

data "aws_caller_identity" "aws-info" {}