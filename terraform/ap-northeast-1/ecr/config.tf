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
    bucket = "infra-workshop-terraform-oharu"
    key    = "ap-northeast-1/ecr.tfstate"
    region = "ap-northeast-1"
  }
}
