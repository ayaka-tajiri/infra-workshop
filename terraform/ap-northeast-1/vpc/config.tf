# プロバイダーの定義
provider "aws" {
  region = "ap-northeast-1"
}

# # terraformにもバージョンがあり、勝手にバージョンがあがると互換性がなくなりバグの原因になるのでバージョンを固定しておく
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  # s3に最新のterraformのリソースがあるので、そこを見にいくための設定
  backend "s3" {
    bucket = "infra-workshop-terraform-oharu"
    key    = "ap-northeast-1/vpc.tfstate"
    region = "ap-northeast-1"
  }
}

# このデータソースを使用して、Terraformが許可されている有効なアカウントID、ユーザーID、およびARNにアクセスします。
data "aws_caller_identity" "current" {}
