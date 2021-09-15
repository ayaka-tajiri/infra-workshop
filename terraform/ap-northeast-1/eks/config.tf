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
    key    = "ap-northeast-1/eks.tfstate"
    region = "ap-northeast-1"
  }
}

# S3の中にアウトプットしたものたちが入っている
# ここでstateを作っておくと、他のファイルからそれらを呼び出せるようになる
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "infra-workshop-terraform-oharu"
    key    = "ap-northeast-1/vpc.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = "infra-workshop-terraform-oharu"
    key    = "iam.tfstate"
    region = "ap-northeast-1"
  }
}

data "aws_caller_identity" "current" {}
