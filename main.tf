provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_version = "~> 1.9.5"
  # backend "s3" {
  #   bucket = 必要に応じて設定
  #   key    = 必要に応じて設定
  #   region = "ap-northeast-1"
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68.0"
    }
  }
}
