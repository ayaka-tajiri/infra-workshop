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
    key    = "ap-northeast-1/rds.tfstate"
    region = "ap-northeast-1"
  }
}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "infra-workshop-terraform-tajiri"
    key    = "ap-northeast-1/vpc.tfstate"
    region = "ap-northeast-1"
  }
}
