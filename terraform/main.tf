terraform {
  backend "s3" {
    bucket         = "ayush-eks-terraform-state2252"
    key            = "eks-platform-demo/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "ayush-eks-terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  cidr   = var.cidr
  env    = var.env
  region = var.region
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}