terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
  backend "s3" {
    bucket         = "flask-devops-tf-state-447989883825-euw2-20240518"
    key            = "main/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}