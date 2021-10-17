provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "infra-workshop-terraform-tajiri"
    key    = "iam.tfstate"
    region = "ap-northeast-1"
  }
}

data "aws_caller_identity" "current" {}
