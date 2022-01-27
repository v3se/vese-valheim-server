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
resource "aws_key_pair" "valheim" {
  key_name   = "valheim-admin"
  public_key = var.public_key
}

data "aws_caller_identity" "aws-info" {}

data "aws_vpc" "valheim" {
  default = true
}